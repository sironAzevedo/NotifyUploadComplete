import json
import os
import boto3
from urllib.parse import unquote_plus
import requests
from botocore.exceptions import NoCredentialsError
from datetime import datetime, timedelta

# Configurações (variáveis de ambiente)
BACKEND_URL = os.getenv('BACKEND_URL', 'https://seu-backend.com/api/update-file')
BACKEND_API_KEY = os.getenv('BACKEND_API_KEY')  # Opcional: autenticação


def mes_para_int(mes_extenso):
    """
    Converte o nome do mês por extenso (em português) para seu número correspondente.
    
    Args:
        mes_extenso (str): Nome do mês em português (ex: 'JANEIRO', 'FEVEREIRO').
        
    Returns:
        int: Número do mês (1 a 12) ou None se inválido.
    """
    meses = {
        'JANEIRO': 1,
        'FEVEREIRO': 2,
        'MARÇO': 3,  # Pode usar 'MARCO' sem acento também
        'ABRIL': 4,
        'MAIO': 5,
        'JUNHO': 6,
        'JULHO': 7,
        'AGOSTO': 8,
        'SETEMBRO': 9,
        'OUTUBRO': 10,
        'NOVEMBRO': 11,
        'DEZEMBRO': 12
    }
    
    # Converte para maiúsculas e remove espaços/acentos extras
    mes_extenso = mes_extenso.upper().strip()
    
    # Tratamento para março (com ou sem acento)
    mes_extenso = mes_extenso.replace('Ç', 'C')
    
    return meses.get(mes_extenso)

def extrair_partes_do_path(path):
    """
    Extrai partes específicas do caminho (ano, mês, usuário, nome do arquivo e extensão).
    Remove o prefixo 'USER_' do campo usuário e separa o arquivo da extensão.
    
    Args:
        path (str): O caminho do arquivo ou diretório.
        
    Returns:
        dict: Um dicionário com as partes do caminho, incluindo extensão.
    """
    itens = [item for item in path.split('/') if item]
    
    usuario = itens[3].replace("USER_", "")  # Remove "USER_" do usuário
    
    # Separa o nome do arquivo e a extensão
    nome_arquivo, extensao = itens[4].rsplit('.', 1)  # Divide no último ponto
    
    partes = {
        'pasta_raiz': itens[0],
        'ano': itens[1],
        'mes': itens[2],
        'usuario': usuario,
        'arquivo': nome_arquivo,  # Nome do arquivo sem extensão
        'extensao': extensao      # Extensão do arquivo (ex: pdf)
    }
    return partes

def gerar_url_pre_assassinada_s3(bucket_name, object_key, expiration_hours=168):
    """
    Gera uma URL pré-assinada para um objeto no Amazon S3.
    
    Args:
        bucket_name (str): Nome do bucket S3.
        object_key (str): Chave do objeto (caminho completo no bucket).
        expiration_hours (int): Tempo de expiração da URL em horas (padrão: 168 hora que é igual a 7 dias).
        
    Returns:
        str: URL pré-assinada ou None em caso de erro.
    """
    # Configura o cliente S3
    s3_client = boto3.client('s3')
    
    try:
        # Gera a URL pré-assinada
        url = s3_client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucket_name, 
                'Key': object_key,
                'ResponseContentDisposition': 'inline',
            },
            ExpiresIn=expiration_hours * 3600  # Converte horas para segundos
        )
        return url
    except NoCredentialsError:
        print("Erro: Credenciais AWS não encontradas.")
        return None
    except Exception as e:
        print(f"Erro ao gerar URL pré-assinada: {e}")
        return None

def enviar_mensagem_para_qualquer_fila(fila_url, mensagem):
    sqs = boto3.client('sqs')
    response = sqs.send_message(
        QueueUrl=fila_url,
        MessageBody=mensagem
    )
    return response

def lambda_handler(event, context):
    # Processa cada registro do evento S3
    for record in event['Records']:
        # Obtém informações do arquivo no S3
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])  # Decodifica caracteres especiais
        
        print(f"Novo upload detectado: {key} no bucket {bucket}")

        # Dados para enviar ao backend
        payload = {
            "bucket": bucket,
            "key": key,
            "eventTime": record['eventTime']
        }
        partes = extrair_partes_do_path(key)
        url = gerar_url_pre_assassinada_s3(bucket, key)

        payloadDTO = {
            "ano": partes['ano'],
            "mes": mes_para_int(partes['mes']),
            "usuario": partes['usuario'],
            "nomeFatura": partes['arquivo'],
            "url": url
        }

        paylaod_saida = json.dumps(payloadDTO)
        print(paylaod_saida)

        enviar_mensagem_para_qualquer_fila("", paylaod_saida)

        
    return {
        'statusCode': 200,
        'body': json.dumps(payload)
    }