class UnifyLanguages

  def self.call
    clean_language_name
    unify_languages
    populate_languages_table
  end

  def self.clean_language_name
    Language.all.each do |language|
      language.name = language.name.downcase.strip
      language.save(validate: false)
    end
  end

  def self.unify_languages
    languages_to_trim = Language.group(:name).count.select{ |language, count| count > 1 }.keys

    languages_to_trim.each do |language_name|
      same_languages = Language.where(name: language_name)
      original_language = same_languages.first
      UsersLanguage.where(language: same_languages).each do |user_language|
        user_language.update(language: original_language)
      end

      same_languages.where.not(id: original_language.id).each(&:destroy)
    end
  end

  def self.populate_languages_table
    LanguageList::COMMON_LANGUAGES.each do |language|
      Language.create(name: language.name.downcase)
    end
  end
end
