Vim�UnDo� �+\�%�i���a{�䚖��r
<�K���Wu  4   D            if string.match(escape_chars_regex) || string.length < 3     0      
       
   
   
    V�C    _�                             ����                                                                                                                                                                                                                                                                                                                            �                     V        V��     �           5�_�                           ����                                                                                                                                                                                                                                                                                                                            �                     V        V��     �          5�_�                           ����                                                                                                                                                                                                                                                                                                                            �                     V        V��     �          �          5�_�                          ����                                                                                                                                                                                                                                                                                                                            �                     V        V��    �      4          def fulltext_keyword5�_�                      [    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V��    �      4      �      words = Shellwords.shellwords(self.downcase.gsub(/[']/, '\\\\\'').gsub(/["]/, '\\"')).reject{|item| SEARCH_STOP_WORDS.include?(item) || item.length == 1}.uniq5�_�                      
    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V�v     �      4      3          unless SEARCH_STOP_WORDS.include?(string)5�_�                      
    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V�x     �      4                else5�_�      	                
    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V�y     �      4      ;            str_arr << string.gsub(escape_chars_regex, " ")5�_�      
           	     
    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V�z    �      4                end5�_�   	               
     0    ����                                                                                                                                                                                                                                                                                                                              [         �       v   �    V�B    �      4      D            if string.match(escape_chars_regex) || string.length < 35��