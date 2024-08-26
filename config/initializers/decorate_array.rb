class Array

  # sample-delete an array down to a maximum size
  def downsample(max_size = 100)
    arr = self.dup

    diff = arr.size - max_size
    return arr if diff <= 0

    # ratio = 3 # fixed
    until arr.size <= max_size
      # arr = arr.reject.with_index { |_, i| (i+1) % ratio == 0 }

      i = rand(max_size)
      next if i == 0 || i == (max_size - 1)
      arr.delete_at(i)
    end

    # p arr.size
    # p arr
    arr
  end
end
