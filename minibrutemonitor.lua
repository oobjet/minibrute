function init()
  print("hello")
end

brute = midi.connect(1)

brute.event = function (d)
  data = midi.to_msg(d)
  print(data.type, data.note, data.cc)
end
