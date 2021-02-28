# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Zenithal

Encoding.default_external = "UTF-8"
$stdout.sync = true


class VivliostyleConverter < ZenithalConverter

  def initialize(document)
    super(document, :text)
  end

  def pass_element(element, scope, close = true)
    tag = Tag.new(element.name, nil, close)
    element.attributes.each_attribute do |attribute|
      tag[attribute.name] = attribute.to_s
    end
    tag << apply(element, scope)
    return tag
  end

  def pass_text(text, scope)
    string = text.to_s
    return string
  end

end


class WholeVivliostyleConverter

  def initialize(args)
    @dirs = {:output => "out", :document => "document", :template => "template"}
    options, rest_args = args.partition{|s| s =~ /^\-\w+$/}
    if options.include?("-s")
      @serve = true
    end
    @rest_args = rest_args
  end

  def execute
    path = File.join(@dirs[:document], "manuscript", "main.zml")
    style_path = File.join(@dirs[:document], "style", "style.scss")
    unless @serve
      convert_normal(path)
      convert_normal(style_path)
    end
    if @serve
      convert_open(path) 
    end
  end

  def convert_normal(path)
    extension = File.extname(path).gsub(/^\./, "")
    output_path = path.gsub(File.join(@dirs[:document], "manuscript"), @dirs[:output]).gsub(File.join(@dirs[:document], "style"), @dirs[:output]).then(&method(:modify_extension))
    case extension
    when "zml"
      parser = create_parser.tap{|s| s.update(File.read(path))}
      converter = create_converter.tap{|s| s.update(parser.run)}
      output = converter.convert
      File.write(output_path, output)
    when "scss"
      option = {}
      option[:style] = :expanded
      option[:filename] = path
      output = SassC::Engine.new(File.read(path), option).render
      File.write(output_path, output)
    when "html", "css"
      output = File.read(path)
      File.write(output_path, output)
    end
  end

  def convert_open(path)
    output_path = path.gsub(File.join(@dirs[:document], "manuscript"), @dirs[:output]).then(&method(:modify_extension))
    command = "npm run server -- -o node_modules/@vivliostyle/viewer/lib#src=../../../../" + output_path
    stdin, stdout, stderr, thread = Open3.popen3(command)
    stdin.close
    stdout.each do |line|
      print(line)
    end
    stderr.each do |line|
      print(line)
    end
    thread.join
  end

  def create_parser(main = true)
    parser = Zenithal::ZenithalParser.new("")
    parser.brace_name = "x"
    parser.bracket_name = "xn"
    parser.slash_name = "i"
    if main
      parser.register_macro("import") do |attributes, _|
        import_path = attributes["src"]
        import_parser = create_parser(false)
        import_parser.update(File.read(File.join(@dirs[:document], import_path)))
        document = import_parser.run
        import_nodes = (attributes["expand"]) ? document.root.children : [document.root]
        next import_nodes
      end
    end
    return parser
  end

  def create_converter
    converter = VivliostyleConverter.new(nil)
    Dir.each_child(@dirs[:template]) do |entry|
      if entry.end_with?(".rb")
        binding = TOPLEVEL_BINDING
        binding.local_variable_set(:converter, converter)
        Kernel.eval(File.read(File.join(@dirs[:template], entry)), binding, entry)
      end
    end
    return converter
  end

  def modify_extension(path)
    result = path.clone
    result.gsub!(/\.zml$/, ".html")
    result.gsub!(/\.scss$/, ".css")
    return result
  end

end


whole_converter = WholeVivliostyleConverter.new(ARGV)
whole_converter.execute