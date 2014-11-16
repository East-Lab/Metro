#!/bin/bash
# rsync [オプション] コピー元 コピー先
# rsync -av -e ssh source user@remote:/path/to/backup
if [ $# -eq 1 ]; then
	rsync -av --exclude 'deployWeb.sh' -e ssh ./* $1:/var/www/vhosts/i-65909a63/
fi
