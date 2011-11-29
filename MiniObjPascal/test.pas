program test;
var
	x: Integer;
	i: Integer;
begin
	x := (10+20)*5;
	write ('x = ');
	writeln (x);
	
	if x > 10 then
	begin
		write ('10+5 = ');
		writeln (10+5);
	end
	else
	begin
		writeln (20);
	end;
	
	i := 0;
	while i < 10 do
	begin
		write ('i = ');
		writeln (i);
		i := i + 1;
	end;
end.