module Combinator
  def powerset(set)
    combs = 2**set.length
    subsets = []

    for i in (0..combs) do
        subset = []
        0.upto(set.length-1){|j| subset<<set[j] if i&(1<<j)!=0}
        subsets << subset
    end

    subsets
  end

  def powerset_enum
    return to_enum(:powerset_enum) unless block_given?
    1.upto(self.size) do |n|
      self.combination(n).each{|i| yield i}
    end
  end
end
