#!/usr/bin/expect -f
 
set timeout -1

spawn gcloud init --skip-diagnostics

expect "Re-initialize this configuration";
send -- "1\r"

expect "Would you like to log in";
send -- "Y\r"

expect {
	# if auth key needed
	-re "enter the verification code provided in your browser"
	{
		set key ""
		while {$key == ""} {
			set k [open "./tmp/login_key.txt" r]
			set key	[read $k]
			close $k

			if {$key != ""} { send -- "$key\r"; exp_continue }
			sleep 1
		}
	}

	# Send Project ID
	-re {\d+] Enter a project ID}
	{ set num $expect_out(0,string); send -- "[lindex [split $num "]"] 0]\r" }
}

set f [open "./tmp/project_id.txt" r]
set extracted_file [split [read $f] "\n"]
set project_id [lindex $extracted_file 0]
close $f

expect  "project ID you would like to use"; 
send -- "$project_id\r"
 
expect eof