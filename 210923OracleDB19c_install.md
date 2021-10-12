# Oracle Database 19c 環境構築
Date 2021/9/23

## 環境
* Ubuntu(20.04.3 LTS)  
* VirtualBox(6.1.26)  
* Vagrant (2.2.6)  
* Oracle Linux Server (7.9)  
* Oracle Database 19c(19.3)  
* Oracle SQL Plus()  

## 手順
1. Ubuntuアップデート  
```
$ sudo apt update
$ sudo apt dist-upgrade
$ sudo apt autoremove
```

2. 仮想環境のバージョン確認  
```
$ VBoxManage -v
$ vagrant -v
```
インストールやバージョンが古い場合はインストールしてください。

3. OracleLinuxのBoxファイルをダウンロード  
	1. Ubuntuで仮想環境の構築する場所へ移動 「/home/ユーザディレクトリ/Boxs/」など  
	2. Oracle公式のVagrantBoxをクローンするして、「vagrant-boxes」をダウンロード  
	```
	$ git clone https://github.com/oracle/vagrant-boxes
	```

4. Oracleインストールモジュールをダウンロード OTNから19cのモジュール（Linux x86-64）  
	1. [Oracle Database 19c](https://www.oracle.com/jp/database/technologies/oracle-database-software-downloads.html)  
	2. 「Oracle Database 19c」-「Linux x86-64」-「ZIP(2.8GB)」  
	3. Oracleプロファイルへのサインインが必要(アカウントを持っていない場合は作成)  
	4. 「Downloads」-「LINUX.X64_193000_db_home.zip」  
	5. ダウンロードしたモジュールをVagrantBox内へ移動  
	```
	$ cp ~/Downloads/LINUX.X64_193000_db_home.zip ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/LINUX.X64_193000_db_home.zip
	```
 
5. インスタンスを起動 vagrant up
	1. 「/vagrant-boxes/OracleDatabase/19.3.0/」内でvagrant upを実行し、初回インストールと仮想マシンの起動(数時間かかる場合もある)
	```
	$ pwd
	~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/
	$ vagrant up
	```

	2. Oracleの管理者(SYSTEM)のパスワードをメモ 
	```
	oracle-19c-vagrant: ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: ★パスワードが表示される★
	```
	※パスワードを忘れてしまった場合は「/home/oracle/」にある「setPassword.sh」スクリプトでリセット可能
	```
	$ cd /home/oracle
	$ ./setPassword.sh ★新しいパスワード★
	```

6. 教科書のサンプルデータをダウンロード
	1. 『ORACLE MASTER Bronze 12c SQL基礎』スクリプトファイル」-「cretab.zip」をBox内にダウンロード
	```
	$ pwd
	~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/
	$ git clone https://github.com/m-akamine/OracleDBinstall.git
	```

7. 仮想マシンへ接続し、OracleDBを起動しデータベースへ接続し、教科書のサンプルデータを取り込む  
	1. 仮想マシンOracleLinuxへ接続しホームディレクトリを確認
	```
	$ vagrant ssh
	$ pwd
	/home/vagrant
	```

	2. 教科書のサンプルデータをOracleDBのホームディレクトリへ移動
	```
	$ sudo cp /vagrant/OracleDBinstall/cretab.sql /home/oracle/cretab.sql
	```

	3. OracleDBを起動しホームディレクトリを確認
	```
	$ sudo su - oracle
	$ pwd
	/home/oracle
	```

	4. sqlplusで管理者としてデータベースに接続  
	```
	$ sqlplus system/★メモしたパスワード★@localhost/orclpdb1
	```

	5. 教科書のサンプルデータ取り込みスクリプトを実行 エラーが出なければOK  
	```
	SQL> @cretab.sql
	```

	6. 接続テスト で取り込んだデータが表示されればOK  
	```
	SQL> SELECT * FROM employees;
	```
8. OracleDBを日本語環境へ変更と自動ログイン
	1. 仮想マシンOracleLinuxへ接続しホームディレクトリを確認
	```
	$ vagrant ssh
	$ pwd
	/home/vagrant
	```

	2. 仮想マシンOracleLinuxを起動した際に、読み込まれる設定ファイル「.bash_profile」を開く
	```
	$ vi /home/vagrant/.bash_profile
	```

	3. 「oracle」ユーザーで自動ログイン 最後の行に追記
	```
	# オラクルユーザでログイン
	sudo su - oralce
	```

	4. OracleDBを起動しホームディレクトリのを確認
	```
	$ sudo su - oracle
	$ pwd
	/home/oracle
	```

	5. OracleDBを起動した際に、読み込まれる設定ファイル「.bash_profile」を開く
	```
	$ vi /home/oracle/.bash_profile
	```

	6. NLS_LANGを日本語のUTF-8で指定する 最後の行に追記
	```
	# NLS_LANGを日本語のUTF-8で指定す
	export NLS_LANG=JAPANESE_JAPAN.AL32UTF8
	export LD_LIBRARY_PATH PATH NLS_LANG

	# データベースのユーザーを自動ログイン
	sqlplus ora01/oracle@localhost/orclpdb1
	```

9. SQL Plusの表示形式を変更するスクリプト
	1. SQL Plusの起動時に書き込んだコマンドを自動実行、読み込まれる設定ファイル「glogin.sql」を開く
	```
	$ vi $ORACLE_HOME/sqlplus/admin/glogin.sql
	```

	2. 「1行の表示幅」「1ページの行数」「特定の列の表示幅(文字と数字)」を指定する 最後の行に追記
	```
	DEFINE_EDITOR="code --wait"

	set null (null)
	set pagesize 30
	set linesize 200
	col first_name for a15
	col last_name for a15
	col name for a15
	col empno for 9999
	col ename for a15
	col yomi for a15
	col job for a15
	col deptno for 999
	col job_id for a10
	col pname for a20
	col department_name for a20
	col city for a20
	col region_name for a30
	col country_name for a30
	col job_title for a20
	col email for a10
	col region for a4
	col dname for a20
	col tname for a20
	set editfile sqlplus.sql
	```

## 毎回の手順
1. 仮想環境のBoxへ移動
`$ cd ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/`

2. 仮想マシンを起動
`$ vagrant up`

3. 仮想マシンへ接続
`$ vagrant ssh`
上記の設定がうまく行っていれば、  
OralceLinux接続→Oracleユーザログイン→SQL Plusにora01ユーザログイン

4. **SQLを勉強する**

5. OracleDBを切断
`SQL> exit`

6. OracleDBを終了
`$ exit`

7. 仮想マシンへ接続を終了
`$ exit`

8. 仮想マシンを終了
`$ vagrant halt`


## データベースの環境

| 接続ユーザ | ユーザー名 | パスワード |
| ---- | ---- | ---- |
| 一般 | ora01 | oracle |
| 管理者 | system | ★仮想環境をインストールした際のパスワード★ |

| VM_ORACLE_BASE | /opt/oracle/ | Oracle base directory |
| VM_ORACLE_HOME | /opt/oracle/product/19c/dbhome_1 | Oracle home directory |
| VM_ORACLE_SID | ORCLCDB | Oracle SID |
| VM_ORACLE_PDB | ORCLPDB1 | PDB name |
| VM_ORACLE_CHARACTERSET | AL32UTF8 | database character set |
| VM_ORACLE_EDITION | EE | Oracle Database edition. Enterprise Edition |
| VM_LISTENER_PORT | 1521 | Listener port |
| VM_EM_EXPRESS_PORT | 5500 | EM Express port |


## 簡易SQL
* [Oracle Live SQL](https://livesql.oracle.com/)  
* [dokoQL](https://dokoql.com/)
