require 'csv'
require 'json'

def timecode_to_frame timecode
  parts = timecode.split(':')
  parts.unshift(0) while parts.size < 4

  count = parts.pop.to_i
  count += parts.pop.to_i * 24
  count += parts.pop.to_i * 24 * 60
  count += parts.pop.to_i * 24 * 60 * 60

  count
end

def num? x
  if /[^\d]/.match(x)
    x
  else
    x.to_i
  end
end

scenes = CSV.read('csv/scenes.csv')

in_header = scenes.shift
out_header = %w(frame_start frame_end frame_length timecode story id order_edit order_chron actors description notes)

result = scenes.map do |scene|
  prochain = scenes[scenes.index(scene) + 1]

  if prochain.nil?
    nil
  else
    commence = timecode_to_frame(scene[0])
    fini = timecode_to_frame(prochain[0]) - 1

    actors = {}
    (7..19).each{ |idx| actors[in_header[idx]] = scene[idx] if !scene[idx].nil? && scene[idx].size > 0 }

    jrow = {}
    out_header.zip([ commence, fini, (fini + 1) - commence, scene[0], num?(scene[1]), num?(scene[2]), num?(scene[3]), num?(scene[4]), actors, scene[22], scene[23] ]).each{ |p| jrow[p[0]] = p[1] }
    jrow
  end
end

result.pop

File.open('json/scenes.json', 'w'){ |f| f << result.to_json }

