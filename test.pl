#!./perl

use Math::GMP;

$test = 0;
$| = 1;
@data = <DATA>;
@tests = grep { ! /^&/ } @data;
print "1..", scalar @tests, "\n";
while (defined($_ = shift @data)) {
  chop;
  if (s/^&//) {
    $f = $_;
  } else {
    ++$test;
    @args = split(/:/,$_,99);
    $ans = pop(@args);
    if ( $args[0] =~ /^i([-+]?\d+)$/ ) {
      $try = "\$x = $1;";
    }
    else {
      $try = "\$x = new Math::GMP \"$args[0]\";";
    }
    if ($f eq "bnorm") {
      $try .= "\$x+0;";
    } elsif ($f eq "bneg") {
      $try .= "-\$x;";
    } elsif ($f eq "babs") {
      $try .= "abs \$x;";
    } else {
      if ( $args[1] =~ /^i([-+]?\d+)$/ ) {
	$try .= "\$y = $1;";
      }
      else {
	$try .= "\$y = new Math::GMP \"$args[1]\";";
      } 
      if ($f eq bcmp) {
	$try .= "\$x <=> \$y;";
      } elsif ($f eq badd) {
	$try .= "\$x + \$y;";
      } elsif ($f eq bsub) {
	$try .= "\$x - \$y;";
      } elsif ($f eq bmul) {
	$try .= "\$x * \$y;";
      } elsif ($f eq bdiv) {
	$try .= "\$x / \$y;";
      } elsif ($f eq bmod) {
	$try .= "\$x % \$y;";
      } elsif ($f eq bdiv2a) {
	$try .= "((Math::GMP::bdiv(\$x, \$y))[0]);";
      } elsif ($f eq bdiv2b) {
	$try .= "((Math::GMP::bdiv(\$x, \$y))[1]);";
      } elsif ($f eq 'bgcd') {
	$try .= "Math::GMP::bgcd(\$x, \$y);";
      } elsif ($f eq 'gcd') {
	$try .= "Math::GMP::gcd(\$x, \$y);";
      } elsif ($f eq 'new_from_base') {
        $try .= "\$x;";
      } elsif ($f eq 'sizeinbase') {
        $try .= "Math::GMP::sizeinbase_gmp(\$x, \$y);";
      } elsif ($f eq 'uintify') {
        $try .= "Math::GMP::uintify_gmp(\$x);";
      } elsif ($f eq 'add_ui') {
        $try .= "Math::GMP::add_ui_gmp(\$x, \$y); \$x";
      } elsif ($f eq 'intify') {
        $try .= "Math::GMP::intify_gmp(\$x);";
      } elsif ($f eq 'mul_2exp') {
        $try .= "Math::GMP::mul_2exp_gmp(\$x, \$y);";
      } elsif ($f eq 'div_2exp') {
        $try .= "Math::GMP::div_2exp_gmp(\$x, \$y);";
      } elsif ($f eq 'mmod') {
       $try .= "Math::GMP::mmod_gmp(\$x, \$y);";
      } elsif ($f eq 'mod_2exp') {
       $try .= "Math::GMP::mod_2exp_gmp(\$x, \$y);";
      } elsif ($f eq 'legendre') {
       $try .= "Math::GMP::legendre(\$x, \$y);";
      } elsif ($f eq 'jacobi') {
       $try .= "Math::GMP::jacobi(\$x, \$y);";
      } else {
        if ( $args[2] =~ /^i([-+]?\d+)$/ ) {
	  $try .= "\$z = $1;";
        } else {
	  $try .= "\$z = new Math::GMP \"$args[2]\";";
        }
	if ($f eq 'powm') {
          $try .= "Math::GMP::powm_gmp(\$x, \$y, \$z);";
	} else {
	  warn "Unknown op";
	}
      }
    }
    #print ">>>",$try,"<<<\n";
    $ans1 = eval $try;
    if ("$ans1" eq $ans) {	#bug!
      print "($f) ok $test\n";
    } else {
      print "($f) not ok $test\n";
      print "# '$f' expected: '$ans' got: '$ans1'\n";
    }
  }
} 
__END__
&bcmp
+0:0:0
-1:0:-1
+0:-1:1
+1:0:1
+0:1:-1
-1:1:-1
+1:-1:1
-1:-1:0
+1:1:0
+123:123:0
+123:12:1
+12:123:-1
-123:-123:0
-123:-12:-1
-12:-123:1
+123:124:-1
+124:123:1
-123:-124:1
-124:-123:-1
+100:5:1
i+100:5:1
+100:i5:1
i-10:-10:0
&badd
+0:0:0
+1:0:1
+0:1:1
+1:1:2
-1:0:-1
+0:-1:-1
-1:-1:-2
-1:1:0
+1:-1:0
+9:1:10
+99:1:100
+999:1:1000
+9999:1:10000
+99999:1:100000
+999999:1:1000000
+9999999:1:10000000
i+9999999:1:10000000
+99999999:1:100000000
+999999999:1:1000000000
+9999999999:1:10000000000
+99999999999:1:100000000000
+99999999999:i1:100000000000
+10:-1:9
+100:-1:99
+1000:-1:999
+10000:-1:9999
+100000:-1:99999
+1000000:-1:999999
+10000000:-1:9999999
+100000000:-1:99999999
+1000000000:-1:999999999
+10000000000:-1:9999999999
+123456789:987654321:1111111110
-123456789:987654321:864197532
-123456789:-987654321:-1111111110
+123456789:-987654321:-864197532
&bsub
+0:0:0
+1:0:1
+0:1:-1
+1:1:0
-1:0:-1
+0:-1:1
-1:-1:0
-1:1:-2
+1:-1:2
+9:1:8
+99:1:98
+999:1:998
+9999:1:9998
+99999:1:99998
+999999:1:999998
+9999999:1:9999998
+99999999:1:99999998
+999999999:1:999999998
+9999999999:1:9999999998
+99999999999:1:99999999998
+99999999999:i1:99999999998
+10:-1:11
+100:-1:101
+1000:-1:1001
+10000:-1:10001
+100000:-1:100001
+1000000:-1:1000001
+10000000:-1:10000001
+100000000:-1:100000001
+1000000000:-1:1000000001
+10000000000:-1:10000000001
+123456789:987654321:-864197532
-123456789:987654321:-1111111110
-123456789:-987654321:864197532
+123456789:-987654321:1111111110
i4:12345678987:-12345678983
&bmul
+0:0:0
+0:1:0
+1:0:0
+0:-1:0
-1:0:0
+123456789123456789:0:0
+0:123456789123456789:0
-1:-1:1
-1:1:-1
+1:-1:-1
+1:1:1
+2:3:6
-2:3:-6
+2:-3:-6
-2:-3:6
+111:111:12321
+10101:10101:102030201
+1001001:1001001:1002003002001
+100010001:100010001:10002000300020001
+10000100001:10000100001:100002000030000200001
+11111111111:9:99999999999
+11111111111:i9:99999999999
i9:+11111111111:99999999999
+22222222222:9:199999999998
+33333333333:9:299999999997
+44444444444:9:399999999996
+55555555555:9:499999999995
+66666666666:9:599999999994
+77777777777:9:699999999993
+88888888888:9:799999999992
+99999999999:9:899999999991
&bdiv2a
+0:1:0
+0:-1:0
+1:1:1
-1:-1:1
+1:-1:-1
-1:1:-1
+1:2:0
+2:1:2
+1000000000:9:111111111
+1000000000:i9:111111111
+2000000000:9:222222222
+3000000000:9:333333333
+4000000000:9:444444444
+5000000000:9:555555555
+6000000000:9:666666666
+7000000000:9:777777777
+8000000000:9:888888888
+9000000000:9:1000000000
+35500000:113:314159
+71000000:226:314159
+106500000:339:314159
+1000000000:3:333333333
+10:5:2
+100:4:25
+1000:8:125
+10000:16:625
i+10000:16:625
+999999999999:9:111111111111
+999999999999:99:10101010101
+999999999999:999:1001001001
+999999999999:9999:100010001
+999999999999999:99999:10000100001
&bdiv
+0:1:0
+0:-1:0
+1:1:1
-1:-1:1
+1:-1:-1
-1:1:-1
+1:2:0
+2:1:2
+1000000000:9:111111111
+1000000000:i9:111111111
+2000000000:9:222222222
+3000000000:9:333333333
+4000000000:9:444444444
+5000000000:9:555555555
+6000000000:9:666666666
+7000000000:9:777777777
+8000000000:9:888888888
+9000000000:9:1000000000
+35500000:113:314159
+71000000:226:314159
+106500000:339:314159
+1000000000:3:333333333
+10:5:2
+100:4:25
+1000:8:125
+10000:16:625
i+10000:16:625
+999999999999:9:111111111111
+999999999999:99:10101010101
+999999999999:999:1001001001
+999999999999:9999:100010001
+999999999999999:99999:10000100001
&bdiv2b
+0:1:0
+0:-1:0
+1:1:0
-1:-1:0
+1:-1:0
-1:1:0
+1:2:1
+2:1:0
+1000000000:9:1
+1000000000:i9:1
+2000000000:9:2
+3000000000:9:3
+4000000000:9:4
+5000000000:9:5
+6000000000:9:6
+7000000000:9:7
+8000000000:9:8
+9000000000:9:0
+35500000:113:33
i+35500000:113:33
+71000000:226:66
+106500000:339:99
+1000000000:3:1
+10:5:0
+100:4:0
+1000:8:0
+10000:16:0
+999999999999:9:0
+999999999999:99:0
+999999999999:999:0
+999999999999:9999:0
+999999999999999:99999:0
&bmod
+0:1:0
+0:-1:0
+1:1:0
-1:-1:0
+1:-1:0
-1:1:0
+1:2:1
+2:1:0
+1000000000:9:1
+1000000000:i9:1
+2000000000:9:2
+3000000000:9:3
+4000000000:9:4
+5000000000:9:5
+6000000000:9:6
+7000000000:9:7
+8000000000:9:8
+9000000000:9:0
+35500000:113:33
i+35500000:113:33
+71000000:226:66
+106500000:339:99
+1000000000:3:1
+10:5:0
+100:4:0
+1000:8:0
+10000:16:0
+999999999999:9:0
+999999999999:99:0
+999999999999:999:0
+999999999999:9999:0
+999999999999999:99999:0
&bgcd
+0:0:0
+0:1:1
+1:0:1
+1:1:1
+2:3:1
+3:2:1
+100:625:25
+4096:81:1
&gcd
+0:0:0
+0:1:1
+1:0:1
+1:1:1
+2:3:1
+3:2:1
+100:625:25
+4096:81:1
&new_from_base
0xff:255
0x2395fa:2332154
&sizeinbase
+5:i10:1
+9999999999:i16:9
-5000:i2:13
&uintify
+15:15
+9999999999:1410065407
+99999999999:1215752191
+999999999999:3567587327
&add_ui
+999999:i1:1000000
+9999999:i1:10000000
+99999999:i1:100000000
&intify
+999999999:999999999
+9999999999:1410065407
&mul_2exp
+9999:i9:5119488
+99999:i9:51199488
+0:i1:0
+1:i0:1
&div_2exp
+999999:i1111:0
+0:i1:0
&powm
+99999:999999:99:27
+1:1:1:0
+1:0:1:0
&mmod
+99999:100002:99999
+1:1:0
&mod_2exp
+99999999:11111:99999999
+0:1:0
&jacobi
+1:15:1
+1:15:1
+2:15:1
+3:15:0
+4:15:1
+5:15:0
+6:15:0
+7:15:-1
+8:15:1
+9:15:0
+10:15:0
+11:15:-1
+12:15:0
+13:15:-1
+14:15:-1
+15:15:0
