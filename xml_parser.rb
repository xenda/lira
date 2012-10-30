require 'xml'
require 'active_support/inflector'

class XMLParser

  attr_accessor :xml_string, :xml, :root

  def initialize(xml_string)
    self.xml_string = xml_string
  end

  def parse
    self.xml = XML::Parser.string(self.xml_string).parse

    self.root = {}
    root_sym = self.xml.child.name.downcase

    self.root[root_sym] = parse_document(self.xml.child)

    self.root
  end

  def parse_document(node)
    hash = {}
    node.children.each do |child_node|
      if child_node.any?
        if child_node.count == 1
          child_node_name = child_node.name.downcase
          child_node_content = parse_string child_node
        else
          child_node_name = child_node.name.downcase.pluralize
          child_node_content = parse_array child_node
        end

        hash[child_node_name] = child_node_content
      end
    end

    hash
  end

  def parse_array(node)
    array = []
    node.children.each do |child_node|
      if child_node.any?
        if child_node.count == 1
          hash = parse_single_node child_node
        else
          hash = parse_array child_node
        end

        array << hash
      end
    end

    return array
  end

  def parse_single_node(node)
    hash = {}
    node_name = node.name.downcase

    hash[node_name] = {}
    hash[node_name]["content"] = parse_string(node)

    if node.attributes?
      hash[node_name] = node.attributes.to_h
    end

    hash
  end

  def parse_string(node)
    node.children.first.to_s
  end

end