#!venv/bin/python3
from fabric import Connection, task
from os import getenv

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

@task
def testlocal(ctx):
    connL.local('ls')
