import { CopyPaste } from './copy_paste.ts'

// /home/index に居る場合、ページ内の動的操作を有効化する
if (!!document.querySelector(CopyPaste.targetClassNameFrom)) {
  CopyPaste.registerEventTriggers()
}
