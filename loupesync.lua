-- generate internal clock from audio pulse clock (CV clock)
-- audio pulse on left input channel
-- midi clock is always in between 100bpm and 200bpm

level = 0
rising = 0
last = util.time()
delta = 0
bpm = 120

function beat()
  delta = util.time() - last
  bpm = 60/delta
  while (bpm < 100 or bpm > 200) do
    if bpm < 100 then bpm = bpm*2 end
    if bpm > 200 then bpm = bpm/2 end
  end
  print (bpm)
  params:set("clock_tempo", bpm)
  last = util.time() 
end

function init()
  p = poll.set("amp_in_r")
  p.callback = function(val) 
    if val>0.5 then 
      if val > level then
        rising = 1
      end
    end 
   if val <= level and rising == 1 then
     rising = 0
     beat()
   end
   level = val
  end
  p.time = 0.005
  p:start()
end

function cleanup()
  p:stop()
end

