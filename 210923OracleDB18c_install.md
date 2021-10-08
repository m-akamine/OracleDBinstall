# Oracle Database 18c 環境構築
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

6. vagrantのインストールの設定を変更する
	1. vagrantの設定ファイル「Vagrantfile」をテキストエディタで開く
	```
	$ vi ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/Vagrantfile
	```

	2. 「Vagrantfile」45行目のタイムゾーンを変更
	```
	VM_SYSTEM_TIMEZONE = default_s('VM_SYSTEM_TIMEZONE', host_tz)
	↓	
	VM_SYSTEM_TIMEZONE = default_s('VM_SYSTEM_TIMEZONE', 'Asia/Tokyo')」
	```

	3. インストール用のスクリプト「install.sh」を「userscripts」にコピーして、名前を「01_install.sh」に変更  
	```
	$ cp ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/scripts/install.sh ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/userscripts/01_install.sh
	```

	4. コピーした「01_install.sh」をテキストエディタで開く  
	```
	$ vi ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/Vagrantfile/userscripts/01_install.sh
	```

	5. 「01_install.sh」26,27行目の言語設定を変更  
	```
	echo LANG=en_US.utf-8 >> /etc/environment
	echo LC_ALL=en_US.utf-8 >> /etc/environment
	↓
	echo LANG=ja_JP.utf-8 >> /etc/environment
	echo LC_ALL=ja_JP.utf-8 >> /etc/environment
	```

 
6. インスタンスを起動 vagrant up
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

7. 教科書のサンプルデータをダウンロード
	1. 『ORACLE MASTER Bronze 12c SQL基礎』スクリプトファイル」-「cretab.zip」をBox内にダウンロード
	```
	$ pwd
	~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/
	$ git clone https://github.com/m-akamine/OracleDBinstall.git
	```

8. 仮想マシンへ接続し、OracleDBを起動しデータベースへ接続し、教科書のサンプルデータを取り込む  
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
9. OracleDBを日本語環境へ変更
	1. OracleDBを起動しホームディレクトリを確認
	```
	$ sudo su - oracle
	$ pwd
	/home/oracle
	```
	2. OracleDBを起動した際に、読み込まれる設定ファイル「.bash_profile」を開く
	```
	$ vi /home/oracle/.bash_profile
	```

	3. NLS_LANGを日本語のUTF-8で指定する 最後の行に追記
	```
	export NLS_LANG=JAPANESE_JAPAN.AL32UTF8
	```

10. SQL Plusの表示形式を変更するスクリプト
	1. SQL Plusの起動時に書き込んだコマンドを自動実行、読み込まれる設定ファイル「glogin.sql」を開く
	```
	$ vi $ORACLE_HOME/sqlplus/admin/glogin.sql
	```

	2. 「1行の表示幅」「1ページの行数」「特定の列の表示幅(文字と数字)」を指定する 最後の行に追記
	```
	SET LINESIZE 150
	SET PAGESIZE 20
	COLUMN yomi FORMAT a10
	COLUMN empno FORMAT 99999
	```

## 毎回の手順
1. 仮想環境のBoxへ移動
`$ cd ~/Boxs/vagrant-boxes/OracleDatabase/19.3.0/`

2. 仮想マシンを起動
`$ vagrant up`

3. 仮想マシンへ接続
`$ vagrant ssh`

4. OracleDBを起動
`$ sudo su - oracle`

5. SQL PlusでOracleDBへ接続(一般ユーザ)
`$ sqlplus ora01/oracle@localhost/orclpdb1`

6. **SQLを勉強する**

7. OracleDBを切断
`SQL> exit`

8. OracleDBを終了
`$ exit`

9. 仮想マシンへ接続を終了
`$ exit`

10. 仮想マシンを終了
`$ vagrant halt`


## データベースの環境

| 接続ユーザ | ユーザー名 | パスワード |
| ---- | ---- | ---- |
| 一般 | ora01 | oracle |
| 管理者 | system | ★仮想環境をインストールした際のパスワード★ |

| 接続ユーザ | ユーザー名 | パスワード |
| ---- | ---- | ---- |
| 一般 | ora01 | oracle |
| 管理者 | system | ★仮想環境をインストールした際のパスワード★ |


## 簡易SQL
* [Oracle Live SQL](https://livesql.oracle.com/)  
* [dokoQL](https://dokoql.com/)

