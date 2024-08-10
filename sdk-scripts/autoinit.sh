#!/usr/bin/expect -f
 
set timeout -1

spawn gcloud init --skip-diagnostics

expect "Re-initialize this configuration";
send -- "1\r"

expect "in to continue";
send -- "Y\r"

expect {
	# if auth key needed
	-re "enter the verification code provided in your browser"
	{
		set AUTH_KEY ""
		while {$AUTH_KEY == ""} {
			set k [open "./tmp/login_key.txt" r]
			set AUTH_KEY [read $k]
			close $k

			if {$AUTH_KEY != ""} { send -- "$AUTH_KEY\r"; exp_continue }
			sleep 1
		}
	}

	-re {\d+] Enter a project ID} 			# Select Project ID
	# -re {\d+] qwiklabs-resources}			# Use Qwiklab Resource for faster init
	{ set num $expect_out(0,string); send -- "[lindex [split $num "]"] 0]\r" }
}

set f [open "./tmp/project_id.txt" r]
set PROJECT_ID [read $f]
close $f

expect  "project ID you would like to use"; 
send -- "$PROJECT_ID\r"
 
expect eof