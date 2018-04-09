require 'minitest/autorun'

describe FindImages do
  before do
    @images = ListImages.run!
  end

  describe 'when sort_data passed' do
    it 'must respond' do
      result = FindImages.run(params: { condition_search: '',
                                        sort_data: 'true' })
      result.result.must_equal @images.reorder(created_at: :DESC)
    end
  end

  describe 'when sort_upvote passed' do
    it 'must respond' do
      result = FindImages.run(params: { condition_search: '',
                                        sort_upvote: 'true' })
      result.result.must_equal @images.reorder(likes_img: :ASC)
    end
  end
end
