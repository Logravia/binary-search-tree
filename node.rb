#!/usr/bin/env ruby
# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def leaf?
    @left.nil? and @right.nil?
  end

  def single_child?
    # If the_child returns nil there are either multiple children or none
    !the_child.nil?
  end

  def the_child
    if leaf?
      nil
    elsif @left.nil? && !@right.nil?
      @right
    elsif !@left.nil? && @right.nil?
      @left
    end
  end

  def <=>(other)
    @data <=> other.data
  end
end
