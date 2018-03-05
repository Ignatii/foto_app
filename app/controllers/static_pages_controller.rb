class StaticPagesController < ApplicationController
  def home
    @images = Image.all.where(:aasm_state => 'unverified')    
  end

  def help
  end

  def about
  end

  def contacts
  end
end
