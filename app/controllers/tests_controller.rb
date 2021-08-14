class TestsController < ApplicationController

  def index
    @test = Test.all
  end

  def show
  end

  def new
    @test = Test.new
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      redirect_to new
    end
  end

  def edit
  end

  def update
  end

  def destory
  end

  private
  def test_params
    params.require(:test).permit(:test)
  end

end
