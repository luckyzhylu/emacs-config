#!/usr/bin/perl -w

open(IN,"function.list");
while(my $line=<IN>){
    chomp($line);
    # print $line . "\n";
    &mk_snippet($line);
}
close(IN);

sub mk_snippet()
{
    my $func_string = shift(@_);

    my @list = split(/[\(\),]/, $func_string);
    if ($#list < 0) {
        # print "$#list, it is ok\n";
        return;
    }
    # print("func_string:$func_string\n");
    # print "aaaa:@list\n";
    my $ret_and_func_name = shift(@list);
    my $pos = rindex($ret_and_func_name, "*");
    if ($pos < 0) {
        $pos = rindex($ret_and_func_name, " ");
    }
    my $func_name = substr($ret_and_func_name, $pos + 1, length($ret_and_func_name));
    if (length($func_name) < 2) {
        return;
    }
    my $ret_str = substr($ret_and_func_name, 0, $pos + 1);
    if (length($ret_str) < 2) {
        return;
    }

    if ($list[$#list] eq ";") {
        # skip the ';' at the end
        pop(@list);
    }
    # print "func_name:$func_name,ret_str=$ret_str;arg=@list\n";
    if ($#list >= 0) {
        &write_snippet_file($ret_str, $func_name, @list);
    }
}


sub write_snippet_file()
{
    my $return = shift(@_);
    my $func_name = shift(@_);;
    my @arg_list = @_;
    my $num = 1;

    # print("return=$return,func_name=$func_name,arg_list=@arg_list\n");

    my $out_string = "(";
    foreach my $arg (@arg_list) {
        $arg =~ s/^\s+|\s+\$//g; # 去除开头与结尾的空格字符
        my $format_str = sprintf("\${%d:%s}, ", $num, $arg);
        # $out_string = $out_string .  $format_str;

        $out_string .= $format_str;
        $num++;
    }
    $out_string = substr($out_string, 0, rindex($out_string, ","));
    $out_string .= ");";

    if (index($return, "*") > 0) {
        $return = sprintf("(\${%d:%s})", $num, $return);
    } else {
       $return = "";
    }

    # print "$return$func_name$out_string\n";

    open(MYFILE, ">", $func_name . "x") or die "open file failed";
    select(MYFILE);
    print("#name : $func_name ()\n");
    print("# --\n");
    print("$return$func_name$out_string");
    close(MYFILE);
}