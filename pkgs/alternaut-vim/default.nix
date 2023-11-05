{ alternautSrc, vimUtils, ... }: vimUtils.buildVimPlugin {
  pname = "alternaut.vim";
  version = "2021-04-01";
  src = alternautSrc;
  meta.homepage = "https://github.com/PsychoLlama/alternaut.vim";
}
