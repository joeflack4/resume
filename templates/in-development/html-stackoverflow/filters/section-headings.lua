-- filters/section-headings.lua
-- Pandoc Lua filter: wrap all level-2 headers in a <section><header>... structure

function Header(el)
  if el.level == 2 then
    local title = pandoc.utils.stringify(el.content)

    return {
      pandoc.RawBlock("html",
        '<section class="section"><header><h2 class="section-title">' ..
        title ..
        '</h2></header></section>'
      )
    }
  end
end
