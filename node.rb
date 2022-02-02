#!/usr/bin/env ruby

class Node
  include Comparable
  attr_accessor :data, :left, :right
  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end
  def <=>(other_node)
    @data <=> other_node.data
  end
end
