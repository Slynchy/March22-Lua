function lerp(a, b, t)
  return a + (b - a) * t
end

frame = 0;
for i=0,255,1 
do 
	frame = lerp(frame, 255, 0.05);
	print(frame);
end