-- change minibrute vanilla 2 SE
-- Arpegiator 2 sequencer

brute = midi.connect(1)

function init()
  brute:send{0xf0} -- sysex begin
  brute:send{0x00} 
  brute:send{0x20} 
  brute:send{0x6b} 
  brute:send{0x04} 
  brute:send{0x01} 
  brute:send{0x75} 
  brute:send{0x01} 
  brute:send{0x3e} 
  brute:send{0x01} 
  brute:send{0xf7} 
  print ("restart your minibrute")
end
  
  