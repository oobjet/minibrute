pattern_time = require 'pattern_time' -- use the pattern_time lib in this script

function init()
  enc_pattern = pattern_time.new() -- establish a pattern recorder
  enc_pattern.process = parse_enc_pattern -- assign the function to be executed when the pattern plays back

  enc_value = 0
  pattern_message = "press K3 to start recording"
  erase_message = "(no pattern recorded)"
  overdub_message = ""


  screen_dirty = true
  screen_timer = clock.run(
    function()
      while true do
        clock.sleep(1/15)
        if screen_dirty then
          redraw()
          screen_dirty = false
        end
      end
    end
  )
end

function record_enc_value()
  enc_pattern:watch(
    {
      ["value"] = enc_value
    }
  )
end

function parse_enc_pattern(data)
  enc_value = data.value
  screen_dirty = true
end

function key(n,z)
  if n == 3 and z == 1 then
    if enc_pattern.rec == 1 then -- if we're recording...
      enc_pattern:rec_stop() -- stop recording
      enc_pattern:start() -- start playing
      pattern_message = "playing, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = "hold K1 to overdub"
    elseif enc_pattern.count == 0 then -- otherwise, if there are no events recorded..
      enc_pattern:rec_start() -- start recording
      record_enc_value()
      pattern_message = "recording, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = ""
    elseif enc_pattern.play == 1 then -- if we're playing...
      enc_pattern:stop() -- stop playing
      pattern_message = "stopped, press K3 to play"
      erase_message = "press K2 to erase"
      overdub_message = ""
    else -- if by this point, we're not playing...
      enc_pattern:start() -- start playing
      pattern_message = "playing, press K3 to stop"
      erase_message = "press K2 to erase"
      overdub_message = "hold K1 to overdub"
    end
  elseif n == 2 and z == 1 then
    enc_pattern:rec_stop() -- stops recording
    enc_pattern:stop() -- stops playback
    enc_pattern:clear() -- clears the pattern
    erase_message = "(no pattern recorded)"
    pattern_message = "press K3 to start recording"
    overdub_message = ""
  elseif n == 1 then
    enc_pattern:set_overdub(z) -- toggles overdub
    overdub_message = z == 1 and "overdubbing" or "hold K1 to overdub"
  end
  screen_dirty = true
end

function enc(n,d)
  if n == 3 then
    enc_value = enc_value + d
    record_enc_value()
    screen_dirty = true
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0,10)
  screen.text("encoder 3 value: "..enc_value)
  screen.move(0,40)
  screen.text(pattern_message)
  screen.move(0,50)
  screen.text(erase_message)
  screen.move(0,60)
  screen.text(overdub_message)
  screen.update()
end
