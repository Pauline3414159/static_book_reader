class Book
  def initialize(title, author)
    @title = title
    @author = author
    @table_of_contents = IO.read("data/toc.txt").split("\n")
    @contents = []
    build_book
  end

  def search_book(terms)
    results = Array.new(self.table_of_contents.size) { [] }
    contents.each_with_index do |chapter, i|
      results[i] = (chapter.search_chapter(terms))
    end
    results
  end

  attr_reader :title, :author, :table_of_contents, :contents
  private
  attr_writer :contents

  def build_book
    table_of_contents.each_with_index do | chapter_title, i |
      self.contents << Chapter.new((i + 1), chapter_title)
    end
  end

end

class Chapter
  def initialize(chapter_num, chapter_name)
    @chapter_num = chapter_num
    @chapter_name = chapter_name
    @chapter_contents = add_html(chapter_num)
  end

  attr_reader :chapter_name, :chapter_contents, :chapter_num

  def search_chapter(terms)
    results = {}
    self.chapter_contents.each do |paragraph|
      next if paragraph.scan(/\bterms\b/).empty?
      link = paragraph.scan(/chp\d+_paragraph\d+/).first
      n = link.match(/chp(\d+)/).captures.first

      results[(n + "#" + link)] = paragraph
    end
    results
  end

  private

  def add_html(num)
    IO.read("data/chp#{num}.txt").split("\n\n").map.with_index do |paragraph , i|
      "<p id=\"chp#{num}_paragraph#{i+1}\">#{paragraph}</p>"
    end
  end

end

