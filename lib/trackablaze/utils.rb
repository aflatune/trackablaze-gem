class Class
  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end

class String
   def underscore
       self.gsub(/::/, '/').
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
   end
end