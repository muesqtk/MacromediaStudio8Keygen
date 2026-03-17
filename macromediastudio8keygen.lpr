program macromediastudio8keygen;

{$MODE OBJFPC}{$H+}

uses
  SysUtils, Math;

function ComputeChecksum(s: Int64; p2: Integer = 5; p3: Integer = 323; p4: Integer = 800): Integer;
var
  d: array[0..6] of Int64;
  powers: array[0..6] of Int64 = (10, 100, 1000, 10000, 100000, 1000000, 1); // Вспомогательный массив
  p3a, p3b, p4a, p4b: Integer;
  A, B, C, D_val: Integer;
  i: Integer;
begin
  // Эмуляция d = {n: s//n for n in [...]}
  d[0] := s div 10;
  d[1] := s div 100;
  d[2] := s div 1000;
  d[3] := s div 10000;
  d[4] := s div 100000;
  d[5] := s div 1000000;

  p3a := p3 div 10;
  p3b := p3 div 100;
  p4a := p4 div 10;
  p4b := p4 div 100;

  A := ((d[1] + p4b + p3a) * 7 + p3b + (d[3] + (s + p4a) * 3 + d[5] + d[0]) * 3 + d[2] + d[4] + p2 + p3) mod 10;
  B := ((d[5] + d[2]) * 7 + p4b + (p4a + p3a * 3 + p3b + d[1]) * 3 + d[3] + d[0] + d[4] + s + p2 + p3) mod 10;
  C := ((d[0] * 7 + p4a + (d[5] + d[2] + p3 * 3 + p3a) * 3 + p4b + p3b + d[3] + d[1] + d[4] + s + p2) mod 10);
  D_val := ((d[2] + p3) * 7 + p4a + (d[0] + (d[4] + p3a + p2) * 3 + d[1]) * 3 + p4b + p3b + d[3] + d[5] + s) mod 10;

  Result := A + B * 10 + C * 100 + D_val * 1000;
end;

procedure WriteDigits(var buf: string; val: Int64; count: Integer; positions: array of Integer);
var
  s: string;
  i: Integer;
begin
  // Форматируем число с ведущими нулями (аналог zfill)
  s := IntToStr(val);
  while Length(s) < count do s := '0' + s;

  for i := 0 to High(positions) do
  begin
    buf[positions[i]] := s[i + 1];
  end;
end;

function GenerateKey: string;
var
  serial, chk: Int64;
  buf: string;
begin
  Randomize;

  // Генерация serial по формуле из Python
  // Используем GetTickCount64 для эмуляции time.monotonic()
  serial := (Random(32768) * Int64(GetTickCount64)) mod $895441 + $B491C;

  chk := ComputeChecksum(serial);

  buf := 'WPD800-00000-00000-00000';

  // Запись цифр в буфер (индексы в Pascal для string начинаются с 1)
  WriteDigits(buf, 5,      1, [8]);
  WriteDigits(buf, serial, 7, [16, 15, 22, 21, 24, 20, 23]);
  WriteDigits(buf, 323,    3, [11, 18, 17]);
  WriteDigits(buf, chk,    4, [9, 10, 12, 14]);

  Result := buf;
end;

begin
  Writeln('Generated Key: ', GenerateKey);
  Readln;
end.
