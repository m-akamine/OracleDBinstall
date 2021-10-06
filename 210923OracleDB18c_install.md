# Oracle Database 18c 環境構築
Date 2021/9/23

## 環境
* Ubuntu(20.04.3 LTS)  
* VirtualBox(6.1.26)  
* Vagrant (2.2.6)  
* Oracle Database 19c(19.3)  

## 手順
1. Ubuntuアップデート  
`$ sudo apt update`  
`$ sudo apt dist-upgrade`  
`$ sudo apt autoremove`  

2. 仮想環境のバージョン確認  
`$ VBoxManage -v`  
`$ vagrant -v`  

インストールやバージョンが古い場合はインストールしてください。

3. Oracle公式のVagrantBoxをクローンする git clone  
`$ git clone https://github.com/oracle/vagrant-boxes`  
	1. Ubuntuで仮想環境の構築する場所へ移動 「/home/ユーザディレクトリ/Boxs/」など  
	2. `$ git clone https://github.com/oracle/vagrant-boxes`  

4. インストールモジュールをダウンロード  
OTNから19cのモジュール（Linux x86-64）をダウンロードする  
	1. [Oracle Database 19c](https://www.oracle.com/jp/database/technologies/oracle-database-software-downloads.html)  
	2. 「Oracle Database 19c」-「Linux x86-64」-「ZIP(2.8GB)」  
	3. Oracleプロファイルへのサインインが必要(アカウントを持っていない場合は作成)  
	4. 「Downloads」-「LINUX.X64_193000_db_home.zip」  

5. ダウンロードしたモジュールをVagrantBox内へ移動  
	1. 「`~/Downloads/LINUX.X64_193000_db_home.zip`」を、VagrantBoxの「`~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/`」へ移動  
	`$ unzip ~/Downloads/LINUX.X64_193000_db_home.zip -d ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/`  

6. インスタンスを起動 vagrant up
	1. 「~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/」内で`$ vagrant up`を実行  

	2. パスワードをメモ `oracle-19c-vagrant: ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: ★パスワードが表示される★`  

7. oraenvでOracle関連の環境変数をセット  
	1. `vagrant ssh`  
	2. oraenvでOracle関連の環境変数をセット  
	```
	[vagrant@oracle-18c-vagrant ~]$ . oraenv
	ORACLE_SID = [ORCLPDB1] ? ORCLPDB1
	ORACLE_HOME = [/home/oracle] ? /opt/oracle/product/19c/dbhome_1
	ORACLE_BASE environment variable is not being set since this
	information is not available for the current user ID vagrant.
	You can set ORACLE_BASE manually if it is required.
	Resetting ORACLE_BASE to its previous value or ORACLE_HOME
	The Oracle base remains unchanged with value /opt/oracle/product/19c/dbhome_1
	```
	3. sqlplusでデータベースに接続  
	`$ sqlplus system/★メモしたパスワード★@localhost/orclpdb1`  
	
	4. 接続テスト 日付がでればOK  
	`SQL> select sysdate from dual;`  

8. 教科書のサンプルデータを入れる
	1. [https://www.sbcr.jp/product/4797375411/](https://www.sbcr.jp/product/4797375411/)
	2. 上記のサイトから「サポート情報」-「【ダウンロード】『ORACLE MASTER Bronze 12c SQL基礎』スクリプトファイル」-「cretab.zip」をダウンロード
	3. https://github.com/m-akamine/OracleDBinstall.git

## 簡易SQL
* [Oracle Live SQL](https://livesql.oracle.com/)  
* [dokoQL](https://dokoql.com/)
