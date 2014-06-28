# -*- encoding: utf-8 -*-


class Respond

  attr_accessor :responce, :targets

  def initialize(responce, targets)
    @responce, @targets = responce, targets
  end

  def to_s
    "#{@responce}||#{@targets.join}"
  end

end
