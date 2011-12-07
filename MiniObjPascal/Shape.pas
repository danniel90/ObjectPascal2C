program Shape;
 
type
  TEllipse = class
	xr: Integer;
	yr: Integer;
	procedure Draw; virtual;
	procedure Hide; virtual;
	procedure Rotate(angle: Integer); virtual;
  end;
  
  TCircle = class (TEllipse)
	procedure Rotate(angle: Integer); override;
	function Center: Integer; virtual;
  end;
 
procedure TEllipse.Draw;
begin
  Writeln('TEllipse.Draw !');
end;

procedure TEllipse.Hide;
begin
  Writeln('TEllipse.Hide !');
end;

procedure TEllipse.Rotate(angle: Integer);
begin
  Write('TEllipse.Rotate: ');
  Writeln(angle);
end;

procedure TCircle.Rotate(angle: Integer);
begin
  Write('TCircle.Rotate: ');
  Writeln(angle);
end;

function TCircle.Center: Integer;
begin
  Write('TCircle.Center !');
  Result := 10;
end;

var
  ellipse: TEllipse;
  circle: TCircle;
  p: TEllipse;

begin
	ellipse := TEllipse.Create;
	circle := TCircle.Create;
	ellipse.Draw;
	circle.Draw;
	ellipse.Rotate(180);
	circle.Rotate(360);

	p := circle;
	p.Rotate(90);
	p := ellipse;
	p.Rotate(80);

	ellipse.Free;
	circle.Free;
end. 

