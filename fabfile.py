#!venv/bin/python3
from fabric import Connection, task
from os import getenv

# Pass host(s) with `-H host1,host2,...,hostN`

# Each task function must have at least one required argument for
#...the connection context, built from the command line options.

conn = Connection(user='ubuntu', host='54.90.28.253')  # host='172.26.6.58'
conn2 = Connection(
        user='ubuntu',
        host='18.195.253.112',
        connect_kwargs={
            "key_filename": "/home/userland/.ssh/aws_pkey",
            },
        )
connL = Connection(host='localhost')

# All @task need a [connection] context required argument

local = getenv('env', '')

@task
def hello(c, who="everybody"):
    res = conn.run('sudo ls /')
    # print(res.ok)

@task
def install_nginx(ctx):
    ''' CONFIGSYS 1
    '''
    # res = conn2.run('hostname')
    # res2 = conn2.run('uname -s')
    # res3 = conn2.run('which nginx')
    # print(res3.failed, res3.ok)
    if local:
        conn2.local('sudo apt update')
        conn2.local('sudo apt install nginx -y')
    else:
        conn2.run('sudo apt update')
        conn2.run('sudo apt install nginx -y')

@task
def install_puppet5(ctx):
    ''' CONFIGSYS 2
    '''
    if local:
        ctx.local('apt-get install -y ruby=1:2.7+1 --allow-downgrades')
        ctx.local('apt-get install -y ruby-augeas')
        ctx.local('apt-get install -y ruby-shadow')
        ctx.local('apt-get install -y puppet=5.5.0')  # or leave out version number
        ctx.local('gem install puppet-lint')
    else:
        ctx.run('apt-get install -y ruby=1:2.7+1 --allow-downgrades')
        ctx.run('apt-get install -y ruby-augeas')
        ctx.run('apt-get install -y ruby-shadow')
        ctx.run('apt-get install -y puppet=5.5.0')
        ctx.run('gem install puppet-lint')

@task
def install_nvm(ctx):
    ''' CONFIGSYS 3
    '''
    if local:
        ctx.local('curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash')
        ctx.local('export NVM_DIR=$HOME/.nvm')
        ctx.local('[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"')  # loads nvm
        ctx.local('[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"')  # loads nvm bash_completion
        ctx.local('source $HOME/.bashrc')
    else:
        ctx.run('curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash')
        ctx.run('export NVM_DIR=$HOME/.nvm')
        ctx.run('[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"')  # loads nvm
        ctx.run('[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"')  # loads nvm bash_completion
        ctx.run('source $HOME/.bashrc')

# start block SPS for setting up Servet presentation server
@task
def install_puppet5(ctx):
    ''' Setup environments and install modules.

        Apply right after updating apt package index.
    '''
    # Install Puppet 5.5
    connL.local('source install_puppet.sh')
    # Create module environment
    connL.local('sudo mkdir -p /etc/puppet/code/environments/servet')
    # Copy the modules Puppetfile to the right environment
    connL.local('sudo cp Puppetfile /etc/puppet/code/environments/servet/')
    # Install the modules in the servet environment
    connL.local('cd /etc/puppet/code/environments/servet/ && sudo r10k puppetfile install --verbose')

@task
def OpenSSL_fix(ctx):
    ''' Applies a fix for a potential Python OpenSSL-crypto bug.

        Apply before installing packages with pip/3.
    '''
    if connL.local('test -d /usr/local/lib/python3.8/dist-packages/OpenSSL', warn=True).ok:
        connL.local('sudo rm -rf /usr/local/lib/python3.8/dist-packages/OpenSSL')

    if connL.local('test -d /usr/local/lib/python3.8/dist-packages/pyOpenSSL-*.dist-info/', warn=True).ok:
        connL.local('sudo rm -rf /usr/local/lib/python3.8/dist-packages/pyOpenSSL-*.dist-info/')
        ''' The `*` above should capture the version number of OpenSSL.
        '''

    connL.local('pip3 install pyOpenSSL==22.0.0')

@task
def install_mysqlclient(ctx):
    ''' Installs pre-requisites for the smooth installation of mysqlclient.
        Needed to use MySQLdb database connector for MySQL.

        Apply after Python3 and pip installed, and OpenSSL fix applied..
    '''
    # if connL.local('which mysqlclient', warn=True).failed:
    # Install requirements
    connL.local('sudo apt-get install python3-dev && sudo apt-get install libmysqlclient-dev && sudo apt-get install zlib1g-dev')
    # Install mysqlclient
    connL.local('sudo pip3 install mysqlclient==2.1.1')


# end block SPS

@task
def testlocal(ctx):
    # connL.local('cd ~ && ls .')
    ''' Context switches back to pwd, after this line, unlike
        with bash where the context remains in the last cd'ed directory.
    '''

    # connL.local('ls')
    ''' Executes in the original wprking
        directory, not that cd'ed into by the last statement.
    '''

    connL.local('ls hgdh')

    # res1 = connL.local('ls .')
    # res2 = connL.local('ls hdhdh')
