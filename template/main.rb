# coding: utf-8


converter.add(["root"], [""]) do |element|
  this = ""
  this << Tag.build("html") do |this|
    this << Tag.build("head") do |this|
      this << Tag.build("link") do |this|
        this["rel"] = "stylesheet"
        this["type"] = "text/css"
        this["href"] = "style.css"
      end
    end
    this << Tag.build("body") do |this|
      this << apply(element, "root")
    end
  end
  next this
end

converter.add(["x", "xn"], [//]) do |element, scope, *args|
  this = ""
  this << Tag.build("span", "sans") do |this|
    this << apply(element, scope, *args)
  end
  next this
end

converter.add(["i"], [//]) do |element, scope, *args|
  this = ""
  this << Tag.build("i") do |this|
    this << apply(element, scope, *args)
  end
  next this
end

converter.add_default(nil) do |text|
  this = ""
  this << text.to_s
  next this
end