#!/bin/bash
######## VARs ########
SMTP_SRV="smtp.office365.com";
SMTP_PORT="587";
SMTP_USR="$(echo -ne "dmluaWNpdXMuYWxjYW50YXJhQHNvbW9zYWdpbGl0eS5jb20uYnI=" | base64 -d)";
SMTP_PASS="$(echo -ne "TXVkYXJAMTIz" | base64 -d)"
MAIL_FROM="$(echo -ne "dmluaWNpdXMuYWxjYW50YXJhQHNvbW9zYWdpbGl0eS5jb20uYnI=" | base64 -d)";
MAIL_TO_1="vinicius.redes2011@gmail.com";
MAIL_TO_2="vinicius.redes2020@gmail.com";
SUBJECT_SUCCESS="SUCCESS: SRM-SRV-";
SUBJECT_FAILED="FAILED: SRM-SRV-";
SUCCESS_NAME_FILE_EMAIL="body_mail_success.txt";
FAILED_NAME_FILE_EMAIL="body_mail_failed.txt";

BODY_MAIL_SUCCESS="
From: "$MAIL_FROM"
To: "$MAIL_TO_1" "$MAIL_TO_2"
Subject: "$SUBJECT_SUCCESS"

Olá,
Espaço em disco liberado com sucesso no servidor/worker mencionado no assunto deste e-mail.
";

BODY_MAIL_FAILED="
From: "$MAIL_FROM"
To: "$MAIL_TO_1" "$MAIL_TO_2"
Subject: "$SUBJECT_FAILED"

Olá,
Falha ao tentar liberar espaço em dsico no servidor/worker mencionado no assunto deste e-mail. Por favor, verificar!

";

######################

function create_body_mail_success() {
	cd ~;
	CURRENT_LOCAL=$(pwd);
	echo "$BODY_MAIL_SUCCESS" | sed 1d > "$CURRENT_LOCAL"/"$SUCCESS_NAME_FILE_EMAIL";  

}

create_body_mail_success;

function create_body_mail_failed() {
        cd ~;
        CURRENT_LOCAL=$(pwd);
        echo "$BODY_MAIL_FAILED" | sed 1d > "$CURRENT_LOCAL"/"$FAILED_NAME_FILE_EMAIL";

}

create_body_mail_failed;

function send_email_success() {

  curl --ssl-reqd \
    --url "$SMTP_SRV":"$SMTP_PORT" \
    --user "$SMTP_USR":"$SMTP_PASS" \
    --mail-from "$MAIL_FROM" \
    --mail-rcpt "$MAIL_TO_1" \
    --mail-rcpt "$MAIL_TO_2" \
    --upload-file "$CURRENT_LOCAL"/"$SUCCESS_NAME_FILE_EMAIL";

  if [ -e "$CURRENT_LOCAL"/"$SUCCESS_NAME_FILE_EMAIL" ]; 
  then
     rm -rf "$CURRENT_LOCAL"/"$SUCCESS_NAME_FILE_EMAIL";
  fi

}

send_email_success;

function send_email_failed() {

  curl --ssl-reqd \
    --url "$SMTP_SRV":"$SMTP_PORT" \
    --user "$SMTP_USR":"$SMTP_PASS" \
    --mail-from "$MAIL_FROM" \
    --mail-rcpt "$MAIL_TO_1" \
    --mail-rcpt "$MAIL_TO_2" \
    --upload-file "$CURRENT_LOCAL"/"$FAILED_NAME_FILE_EMAIL";

  if [ -e "$CURRENT_LOCAL"/"$FAILED_NAME_FILE_EMAIL" ];
  then
     rm -rf "$CURRENT_LOCAL"/"$FAILED_NAME_FILE_EMAIL";
  fi


}

send_email_failed;

