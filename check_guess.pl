#!/usr/bin/perl -w
#perl implementation

# recieve guess from first argument passed
my $guess = $ARGV[0];
my $answer = $ARGV[1];

# check if guess is correct
$result=index($answer, $guess);
print $result;