// 年・月・日 曜日の4要素に分解する
type SplitedDate = [number, number, number, string]

// 3つある、「面談候補日」(<input type="date"/>) を選択時、コピペ用の欄 (<textarea/>) に値を挿入する
class CopyPaste {
  static readonly targetClassNameFrom: string = '.js-apply-date-select-from'
  static readonly targetClassNameTo: string = '.js-apply-date-select-to'

  // copyPasteEvent, copyToClipboardEvent の2つのイベントを登録する
  static registerEventTriggers(): void {
    // 面談候補日関連のページにいない場合、処理を実行しない
    if (this.fromTargets().length === 0) { return }

    this.fromTargets().forEach((event : EventTarget) => {
      event.addEventListener('change', CopyPaste.copyPasteEvent)
    })

    this.toTarget().addEventListener('click', CopyPaste.copyToClipboardEvent)
  }

  // コピペ用の欄 (面談候補日 一覧) をクリック時、クリップボードに値をコピーする
  // メールのやり取りなどでの入力を省力化する
  static copyToClipboardEvent(): void {
    const textarea : HTMLInputElement = <HTMLInputElement>CopyPaste.toTarget()

    textarea.setAttribute('readonly', 'true')
    textarea.select()
    document.execCommand('copy')
  }

  // <input type="date"/> で選択した日付をもとに、コピペ用の欄に値を挿入:
  // eg.
  // 1. n月m日 (月) 14:00〜17:00 に開始
  // 2. n月m日 (月) 14:00〜17:00 に開始
  // 3. n月m日 (月) 14:00〜17:00 に開始
  // 指定できないほうが実装・操作が楽なので時刻は「14:00〜17:00」で固定している
  //
  // addeventlistener() に渡す関係で static メソッドとして定義している
  static copyPasteEvent(): void {
    const from : Element[] = CopyPaste.fromTargets()
    const to : HTMLInputElement = CopyPaste.toTarget()

    const template = (index : number, y : number, m : number, d : number, w: string) => {
      return `${index}. ${y}年${m}月${d}日 (${w}) 14:00〜17:00 に開始`
    }
    let templateResult : string = ''

    let n : number = 0
    from.forEach((element : any) => {
      n++

      if (element.value.length === 0) { return }

      const targetDate = new Date(element.value)
      const [year, month, date, dayOfWeek] : any[] = CopyPaste.splitToYMD(new Date(element.value))
      templateResult += `${template(n, year, month, date, dayOfWeek)}\n`
    })

    to.setAttribute('readonly', 'true')
    to.value = templateResult
  }

  // 与えられた Date を「YYYY, MM, DD, 曜日」 に分解する
  static splitToYMD(selectedDate: Date): SplitedDate {
    const dayOfWeek: string[] = ['日', '月', '火', '水', '木', '金', '土']

    return [
      selectedDate.getFullYear(),
      selectedDate.getMonth() + 1, // 1月は「0」が返ってくる
      selectedDate.getDate(),
      dayOfWeek[selectedDate.getDay()]
    ]
  }

  // 面談候補日の <input type="date"/> 要素群を返す
  static fromTargets(): Element[] {
    return Array.from(
      document.querySelectorAll(this.targetClassNameFrom)
    )
  }

  // コピペ用の欄の <textarea/> 要素を返す
  static toTarget(): HTMLInputElement {
    return document.querySelector(this.targetClassNameTo)
  }
}

export { CopyPaste }
