Olá. 

Para este teste, criei 2 ambientes. Um local e outro no Google Cloud.

1) Ambiente Local (sandbox).

	Para este desafio, imaginei uma arquitetura onde a ingestão possa ser feito atraves do Nifi (Arquitetura.pptx). 

	Poderia usar outros metodos de ingestao, dependendo da origem(banco de dados, microserviço/API, etc).

	O Nifi orquestraria a transferencia do arquivo csv para o cluster em uma area definida(pasta local ou diretamente no cluster).

	Um shell script linux poderia enviar este arquivo csv para o Cluster HDFS.

	Estou usando o Apache Hive como bando de dados para fazer o processamento batch dos arquivos.

	Criei as tabelas (CREATE_TABLES.hql) e fiz a carga do arquivo csv para a tabela atraves do comando LOAD DATA LOCAL INPATH.

	Apos a carga dos arquivos, as tabelas estao prontas para serem consumidas(Relatorios.hql), podendo ser executados relatorios, gerando informações para as ferramentas de visualização.


2) Ambiente Google Cloud
Para recriar este ambiente no Google Cloud, executei os seguintes passos a seguir.

** Cloud Shell: 
	1) Defini uma região / zona padrao do Compute Engine, para os clusters do Dataproc.
		export REGION=us-central1
		export ZONE=us-central1-a
		gcloud config set compute/zone ${ZONE}

	2) Ativei as APIs Admin do Dataproc e do Cloud SQL:
		gcloud services enable dataproc.googleapis.com sqladmin.googleapis.com
		
	3) Criei um bucket de armazenamento de dados:
		export PROJECT=$(gcloud info --format='value(config.project)')
		gsutil mb -l ${REGION} gs://${PROJECT}-warehouse
		
	4) Criei uma instancia no Cloud SQL para armazenar os metadados do Hive:
		gcloud sql instances create hive-metastore \
		--database-version="MYSQL_5_7" \
		--activation-policy=ALWAYS \
		--zone ${ZONE}
		
	5) Criei um Cluster do Dataproc:
		gcloud dataproc clusters create hive-cluster \
		--scopes sql-admin \
		--image-version 1.4 \
		--region ${REGION} \
		--initialization-actions gs://goog-dataproc-initialization-actions-${REGION}/cloud-sql-proxy/cloud-sql-proxy.sh \
		--properties hive:hive.metastore.warehouse.dir=gs://${PROJECT}-warehouse/datasets \
		--metadata "hive-metastore-instance=${PROJECT}:${REGION}:hive-metastore"
		
	6) Acessei o cluster do Dataproc:
		gcloud compute ssh hive-cluster-m
		
	7) Criei o diretorio onde iria disponibilizar os arquivos .csv para ser usado na carga das tabelas:
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -mkdir /user/hive/ricardo_g_souza
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -chmod 777 /user/hive/ricardo_g_souza
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -ls /user/hive/ricardo_g_souza

** Cloud Storage
	8) Fiz upload dos arquivos para o Cloud Storage:
		Fiz upload manual, usando a tela do Cloud Storage

** Cloud Shell:		
	9) Enviei os arquivos do Cloud Storage para o Cluster HDFS.
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -cp gs://testebv-warehouse/bill_of_materials.csv /user/hive/ricardo_g_souza
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -cp gs://testebv-warehouse/comp_boss.csv /user/hive/ricardo_g_souza
		ricardo_g_souza@hive-cluster-m:~$ hdfs dfs -cp gs://testebv-warehouse/price_quote.csv /user/hive/ricardo_g_souza

	10) Acessei o hive para criar as tabelas e fazer a carga dos dados (CREATE_TABLES-GCP.hql):
		ricardo_g_souza@hive-cluster-m:~$ beeline -u "jdbc:hive2://localhost:10000"
	
	11) Após criar as tabelas, ja é possivel executar os relatorios no Hive (Relatorios.hql).
		
