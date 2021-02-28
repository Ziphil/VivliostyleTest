# coding: utf-8


converter.add(["h1", "h2"], ["root"]) do |element|
  this = pass_element(element, "root")
  next this
end

converter.add(["p"], ["root"]) do |element|
  this = pass_element(element, "root.p")
  next this
end

converter.add(nil, ["root.p"]) do |text|
  this = ""
  this << text.value.gsub(/(?<=。)\s*\n\s*/, "")
  next this
end