pattern = require 'lib/pattern_time'
p = pattern.new()
message = "..."

brute = midi.connect(1)

function playback(d)
  brute:send(midi.to_data(d))
end

function init()
  p.process = playback
end

brute.event = function(d)
  data = midi.to_msg(d)
  if data.type then
    p:watch(data)
  end
end

function key(n,z)
  if n==3 and z==1 then
    if p.rec == 0 and p.play == 0 then -- empty, start recording
      p:rec_start()
      message="rec"
    elseif p.rec == 1 then --recording
      p:rec_stop()
      print (p.count)
      if p.count > 0 then
        p:start()
        message = "loop"
      else
        message = "..."
      end
    elseif p.play == 1 then -- playing
        p:stop()
        p:clear()
        message = "..."
    end
      redraw()
  end
end
  
function redraw()
  screen.clear()
  screen.move(64,40)
  screen.text_center(message)
  screen.update()
end

