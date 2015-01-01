module Powerset
  class ::Array
    def powerset_enum
      return to_enum(:powerset_enum) unless block_given?
      1.upto(self.size) do |n|
        self.combination(n).each{|i| yield i}
      end
    end
  end
end
