#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # Calculates the symmetric similarity, K, between two level views
  #
  def PMK.similarity(lv_a, lv_b, params = {})
    nlevels = params[:nlevels] || lv_a.length
    stop = lv_a.length - 1
    start = [0, lv_a.length - nlevels].max

    last = 0
    w = 1.0
    k = 0.0
    for lev in start..stop do
      h_a = lv_a[lev]
      h_b = lv_b[lev]
      i = 0
      h_a.each do |id, c_a|
        c_b = h_b[id]
        i += c_a < c_b ? c_a : c_b
      end

      n = i - last
      k += w * n
      last = i
      w *= 0.5
    end
    k
  end

  #
  # Calculate the normed similarity between two level views.
  #
  def PMK.similarity_normed(lv_a, lv_b, params = {})
    k_ab = similarity(lv_a, lv_b, params)
    k_aa = lv_a.last[0]
    k_bb = lv_b.last[0]
      
    k_ab/Math::sqrt(k_aa*k_bb)
  end
  
end
