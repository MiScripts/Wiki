
#The domain of your accounts, such as @schooldistrict.edu if you use multiple domains you will have to make adjustments to the script 
$Domain = "@***.*******.org"
#Bot Account you want emails to be sent from
$EmailFrom = "autotask$Domain"
#Help Desk you want emails sent
$EmailTo = "helpdesk$Domain" 
#Keep to default or change depending on enviroment
$SMTPServer = "smtp.gmail.com" 
#Keep to default or change depending on enviroment
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
#Keep to default or change depending on enviroment
$SMTPClient.EnableSsl = $true 
#The email and password of the bot account
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("autotask$Domain", "**********"); 
#An array of your staff buildings that can get assigned, you'll have to edit the script if your setup is not setup to Building -> Staff Member
$GlobalBuildings = 'Building1','Building2','Building3','Building4','Building5','Food Service','Maintenance','Transportation'
#CCEmails input emails for what emails you want to alert those buildings 
$CCEmails = @{'Building1'='email1';'Building2'='email2';'Building3'='email3';'Building4'='email4';'Building5'='email5';'Food Service'='email6';'Maintenance'='email7';'Transportation'='email8'}
#For local home folders, can omit this and comment out the script if you do not use home folders
$HomeDirectory = "\\*************\Home\"
#The top level of the AD OU where your staff reside
$ADOU = "OU=******,OU=****,DC=****,DC=***,DC=********,DC=*****"
#Default password for first time logins
$DefaultPassword = "***********"
