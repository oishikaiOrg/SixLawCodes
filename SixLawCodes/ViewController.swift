//
//  ViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/01/25.
//

import UIKit
import SwiftyXMLParser
/*
public struct Chapter: XMLIndexerDeserializable {
    var ChapterTitle : String = ""
    
    init(ChapterTitle: String){
        self.ChapterTitle = ChapterTitle
    }
    public static func deserialize(_ node: XMLIndexer) throws -> Chapter{
        return try Chapter (
            ChapterTitle: node["ChapterTitle"].value()
            )
    }
}
*/

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sixCodes = ["憲法", "刑法", "民法", "商法", "刑事訴訟法", "民事訴訟法"]
    let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        print(indexPath.row) // 引数のidexpathを数値として受け取る
        let setLawNumber = lawNumber[indexPath.row]
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print("https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)")
        // urlにlawNumberを埋め込んで,そのままだと扱えないので .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! でエンコード
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            let xml = XML.parse(data!)
            
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter"]
            
            let chapterNum = text.all?.count ?? 0
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.chapterNum = chapterNum
            }
            //let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
//            nextVC.chapterNum = chapterNum
            print("e")
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        example()
        // Do any additional setup after loading the view.
    }

    func example(){
        let str = """
        <ResultSet>
            <Result>
                <Hit index=\"1\">
                    <Name>Item1</Name>
                </Hit>
                <Hit index=\"2\">
                    <Name>Item2</Name>
                </Hit>
            </Result>
        </ResultSet>
        """

        // parse xml document
        let xml = try! XML.parse(str)

        // access xml element
        let accessor = xml["ResultSet"]

        // access XML Text

        if let text = xml["ResultSet", "Result", "Hit", 0, "Name"].text {
            print("if let text = xml[\"ResultSet\", \"Result\", \"Hit\", 0, \"Name\"].text {")
            print(text)
        }

        if let text = xml.ResultSet.Result.Hit[0].Name.text {
            print("if let text = xml.ResultSet.Result.Hit[0].Name.text {")
            print(text)
        }

        // access XML Attribute
        if let index = xml["ResultSet", "Result", "Hit", 0].attributes["index"] {
            print("if let index = xml[\"ResultSet\", \"Result\", \"Hit\" ,0].attributes[\"index\"] {")
            print(index)
        }

        let hits = xml["ResultSet", "Result", "Hit"]
            print("array hit")
            print(hits)

        let results = xml["ResultSet", "Result"]
            print("array results")
            print(results)

        // enumerate child Elements in the parent Element
        for hit in xml["ResultSet", "Result", "Hit"] {
            print("for hit in xml[\"ResultSet\", \"Result\", \"Hit\"] {")
            print(hit)
        }
        

        // check if the XML path is wrong
        if case .failure(let error) =  xml["ResultSet", "Result", "TypoKey"] {
            print(error)
        }
    }
 
    func article() -> String {
        return """

            <?xml version="1.0" encoding="UTF-8"?>
            <DataRoot>
            <Result>
            <Code>0</Code>
            <Message/>
            </Result>
            <ApplData>
            <LawId/>
            <LawNum>昭和二十一年憲法</LawNum>
            <LawFullText>
            <Law Era="Showa" Year="21" Num="" LawType="Constitution" Lang="ja">
            <LawNum>昭和二十一年憲法</LawNum>
            <LawBody>
            <LawTitle>日本国憲法</LawTitle>
            <Preamble>
            <Paragraph Num="1">
              <ParagraphNum/>
              <ParagraphSentence>
                <Sentence>日本国民は、正当に選挙された国会における代表者を通じて行動し、われらとわれらの子孫のために、諸国民との協和による成果と、わが国全土にわたつて自由のもたらす恵沢を確保し、政府の行為によつて再び戦争の惨禍が起ることのないやうにすることを決意し、ここに主権が国民に存することを宣言し、この憲法を確定する。そもそも国政は、国民の厳粛な信託によるものであつて、その権威は国民に由来し、その権力は国民の代表者がこれを行使し、その福利は国民がこれを享受する。これは人類普遍の原理であり、この憲法は、かかる原理に基くものである。われらは、これに反する一切の憲法、法令及び詔勅を排除する。</Sentence>
              </ParagraphSentence>
            </Paragraph>
            <Paragraph Num="2">
              <ParagraphNum/>
              <ParagraphSentence>
                <Sentence>日本国民は、恒久の平和を念願し、人間相互の関係を支配する崇高な理想を深く自覚するのであつて、平和を愛する諸国民の公正と信義に信頼して、われらの安全と生存を保持しようと決意した。われらは、平和を維持し、専制と隷従、圧迫と偏狭を地上から永遠に除去しようと努めてゐる国際社会において、名誉ある地位を占めたいと思ふ。われらは、全世界の国民が、ひとしく恐怖と欠乏から免かれ、平和のうちに生存する権利を有することを確認する。</Sentence>
              </ParagraphSentence>
            </Paragraph>
            <Paragraph Num="3">
              <ParagraphNum/>
              <ParagraphSentence>
                <Sentence>われらは、いづれの国家も、自国のことのみに専念して他国を無視してはならないのであつて、政治道徳の法則は、普遍的なものであり、この法則に従ふことは、自国の主権を維持し、他国と対等関係に立たうとする各国の責務であると信ずる。</Sentence>
              </ParagraphSentence>
            </Paragraph>
            <Paragraph Num="4">
              <ParagraphNum/>
              <ParagraphSentence>
                <Sentence>日本国民は、国家の名誉にかけ、全力をあげてこの崇高な理想と目的を達成することを誓ふ。</Sentence>
              </ParagraphSentence>
            </Paragraph>
            </Preamble>
            <MainProvision>
            <Chapter Num="1">
              <ChapterTitle>第一章　天皇</ChapterTitle>
              <Article Num="1">
                <ArticleTitle>第一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇は、日本国の象徴であり日本国民統合の象徴であつて、この地位は、主権の存する日本国民の総意に基く。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="2">
                <ArticleTitle>第二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>皇位は、世襲のものであつて、国会の議決した皇室典範の定めるところにより、これを継承する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="3">
                <ArticleTitle>第三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇の国事に関するすべての行為には、内閣の助言と承認を必要とし、内閣が、その責任を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="4">
                <ArticleTitle>第四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇は、この憲法の定める国事に関する行為のみを行ひ、国政に関する権能を有しない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>天皇は、法律の定めるところにより、その国事に関する行為を委任することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="5">
                <ArticleTitle>第五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">皇室典範の定めるところにより摂政を置くときは、摂政は、天皇の名でその国事に関する行為を行ふ。</Sentence>
                    <Sentence Num="2">この場合には、前条第一項の規定を準用する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="6">
                <ArticleTitle>第六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇は、国会の指名に基いて、内閣総理大臣を任命する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>天皇は、内閣の指名に基いて、最高裁判所の長たる裁判官を任命する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="7">
                <ArticleTitle>第七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇は、内閣の助言と承認により、国民のために、左の国事に関する行為を行ふ。</Sentence>
                  </ParagraphSentence>
                  <Item Num="1">
                    <ItemTitle>一</ItemTitle>
                    <ItemSentence>
                      <Sentence>憲法改正、法律、政令及び条約を公布すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="2">
                    <ItemTitle>二</ItemTitle>
                    <ItemSentence>
                      <Sentence>国会を召集すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="3">
                    <ItemTitle>三</ItemTitle>
                    <ItemSentence>
                      <Sentence>衆議院を解散すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="4">
                    <ItemTitle>四</ItemTitle>
                    <ItemSentence>
                      <Sentence>国会議員の総選挙の施行を公示すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="5">
                    <ItemTitle>五</ItemTitle>
                    <ItemSentence>
                      <Sentence>国務大臣及び法律の定めるその他の官吏の任免並びに全権委任状及び大使及び公使の信任状を認証すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="6">
                    <ItemTitle>六</ItemTitle>
                    <ItemSentence>
                      <Sentence>大赦、特赦、減刑、刑の執行の免除及び復権を認証すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="7">
                    <ItemTitle>七</ItemTitle>
                    <ItemSentence>
                      <Sentence>栄典を授与すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="8">
                    <ItemTitle>八</ItemTitle>
                    <ItemSentence>
                      <Sentence>批准書及び法律の定めるその他の外交文書を認証すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="9">
                    <ItemTitle>九</ItemTitle>
                    <ItemSentence>
                      <Sentence>外国の大使及び公使を接受すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="10">
                    <ItemTitle>十</ItemTitle>
                    <ItemSentence>
                      <Sentence>儀式を行ふこと。</Sentence>
                    </ItemSentence>
                  </Item>
                </Paragraph>
              </Article>
              <Article Num="8">
                <ArticleTitle>第八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>皇室に財産を譲り渡し、又は皇室が、財産を譲り受け、若しくは賜与することは、国会の議決に基かなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="2">
              <ChapterTitle>第二章　戦争の放棄</ChapterTitle>
              <Article Num="9">
                <ArticleTitle>第九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>日本国民は、正義と秩序を基調とする国際平和を誠実に希求し、国権の発動たる戦争と、武力による威嚇又は武力の行使は、国際紛争を解決する手段としては、永久にこれを放棄する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">前項の目的を達するため、陸海空軍その他の戦力は、これを保持しない。</Sentence>
                    <Sentence Num="2">国の交戦権は、これを認めない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="3">
              <ChapterTitle>第三章　国民の権利及び義務</ChapterTitle>
              <Article Num="10">
                <ArticleTitle>第十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>日本国民たる要件は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="11">
                <ArticleTitle>第十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">国民は、すべての基本的人権の享有を妨げられない。</Sentence>
                    <Sentence Num="2">この憲法が国民に保障する基本的人権は、侵すことのできない永久の権利として、現在及び将来の国民に与へられる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="12">
                <ArticleTitle>第十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">この憲法が国民に保障する自由及び権利は、国民の不断の努力によつて、これを保持しなければならない。</Sentence>
                    <Sentence Num="2">又、国民は、これを濫用してはならないのであつて、常に公共の福祉のためにこれを利用する責任を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="13">
                <ArticleTitle>第十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">すべて国民は、個人として尊重される。</Sentence>
                    <Sentence Num="2">生命、自由及び幸福追求に対する国民の権利については、公共の福祉に反しない限り、立法その他の国政の上で、最大の尊重を必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="14">
                <ArticleTitle>第十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて国民は、法の下に平等であつて、人種、信条、性別、社会的身分又は門地により、政治的、経済的又は社会的関係において、差別されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>華族その他の貴族の制度は、これを認めない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">栄誉、勲章その他の栄典の授与は、いかなる特権も伴はない。</Sentence>
                    <Sentence Num="2">栄典の授与は、現にこれを有し、又は将来これを受ける者の一代に限り、その効力を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="15">
                <ArticleTitle>第十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>公務員を選定し、及びこれを罷免することは、国民固有の権利である。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>すべて公務員は、全体の奉仕者であつて、一部の奉仕者ではない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>公務員の選挙については、成年者による普通選挙を保障する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="4">
                  <ParagraphNum>○４</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">すべて選挙における投票の秘密は、これを侵してはならない。</Sentence>
                    <Sentence Num="2">選挙人は、その選択に関し公的にも私的にも責任を問はれない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="16">
                <ArticleTitle>第十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、損害の救済、公務員の罷免、法律、命令又は規則の制定、廃止又は改正その他の事項に関し、平穏に請願する権利を有し、何人も、かかる請願をしたためにいかなる差別待遇も受けない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="17">
                <ArticleTitle>第十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、公務員の不法行為により、損害を受けたときは、法律の定めるところにより、国又は公共団体に、その賠償を求めることができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="18">
                <ArticleTitle>第十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">何人も、いかなる奴隷的拘束も受けない。</Sentence>
                    <Sentence Num="2">又、犯罪に因る処罰の場合を除いては、その意に反する苦役に服させられない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="19">
                <ArticleTitle>第十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>思想及び良心の自由は、これを侵してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="20">
                <ArticleTitle>第二十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">信教の自由は、何人に対してもこれを保障する。</Sentence>
                    <Sentence Num="2">いかなる宗教団体も、国から特権を受け、又は政治上の権力を行使してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>何人も、宗教上の行為、祝典、儀式又は行事に参加することを強制されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>国及びその機関は、宗教教育その他いかなる宗教的活動もしてはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="21">
                <ArticleTitle>第二十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>集会、結社及び言論、出版その他一切の表現の自由は、これを保障する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">検閲は、これをしてはならない。</Sentence>
                    <Sentence Num="2">通信の秘密は、これを侵してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="22">
                <ArticleTitle>第二十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、公共の福祉に反しない限り、居住、移転及び職業選択の自由を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>何人も、外国に移住し、又は国籍を離脱する自由を侵されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="23">
                <ArticleTitle>第二十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>学問の自由は、これを保障する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="24">
                <ArticleTitle>第二十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>婚姻は、両性の合意のみに基いて成立し、夫婦が同等の権利を有することを基本として、相互の協力により、維持されなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>配偶者の選択、財産権、相続、住居の選定、離婚並びに婚姻及び家族に関するその他の事項に関しては、法律は、個人の尊厳と両性の本質的平等に立脚して、制定されなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="25">
                <ArticleTitle>第二十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて国民は、健康で文化的な最低限度の生活を営む権利を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>国は、すべての生活部面について、社会福祉、社会保障及び公衆衛生の向上及び増進に努めなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="26">
                <ArticleTitle>第二十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて国民は、法律の定めるところにより、その能力に応じて、ひとしく教育を受ける権利を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">すべて国民は、法律の定めるところにより、その保護する子女に普通教育を受けさせる義務を負ふ。</Sentence>
                    <Sentence Num="2">義務教育は、これを無償とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="27">
                <ArticleTitle>第二十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて国民は、勤労の権利を有し、義務を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>賃金、就業時間、休息その他の勤労条件に関する基準は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>児童は、これを酷使してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="28">
                <ArticleTitle>第二十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>勤労者の団結する権利及び団体交渉その他の団体行動をする権利は、これを保障する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="29">
                <ArticleTitle>第二十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>財産権は、これを侵してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>財産権の内容は、公共の福祉に適合するやうに、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>私有財産は、正当な補償の下に、これを公共のために用ひることができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="30">
                <ArticleTitle>第三十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国民は、法律の定めるところにより、納税の義務を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="31">
                <ArticleTitle>第三十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、法律の定める手続によらなければ、その生命若しくは自由を奪はれ、又はその他の刑罰を科せられない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="32">
                <ArticleTitle>第三十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、裁判所において裁判を受ける権利を奪はれない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="33">
                <ArticleTitle>第三十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、現行犯として逮捕される場合を除いては、権限を有する司法官憲が発し、且つ理由となつてゐる犯罪を明示する令状によらなければ、逮捕されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="34">
                <ArticleTitle>第三十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">何人も、理由を直ちに告げられ、且つ、直ちに弁護人に依頼する権利を与へられなければ、抑留又は拘禁されない。</Sentence>
                    <Sentence Num="2">又、何人も、正当な理由がなければ、拘禁されず、要求があれば、その理由は、直ちに本人及びその弁護人の出席する公開の法廷で示されなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="35">
                <ArticleTitle>第三十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、その住居、書類及び所持品について、侵入、捜索及び押収を受けることのない権利は、第三十三条の場合を除いては、正当な理由に基いて発せられ、且つ捜索する場所及び押収する物を明示する令状がなければ、侵されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>捜索又は押収は、権限を有する司法官憲が発する各別の令状により、これを行ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="36">
                <ArticleTitle>第三十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>公務員による拷問及び残虐な刑罰は、絶対にこれを禁ずる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="37">
                <ArticleTitle>第三十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて刑事事件においては、被告人は、公平な裁判所の迅速な公開裁判を受ける権利を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>刑事被告人は、すべての証人に対して審問する機会を充分に与へられ、又、公費で自己のために強制的手続により証人を求める権利を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">刑事被告人は、いかなる場合にも、資格を有する弁護人を依頼することができる。</Sentence>
                    <Sentence Num="2">被告人が自らこれを依頼することができないときは、国でこれを附する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="38">
                <ArticleTitle>第三十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、自己に不利益な供述を強要されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>強制、拷問若しくは脅迫による自白又は不当に長く抑留若しくは拘禁された後の自白は、これを証拠とすることができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>何人も、自己に不利益な唯一の証拠が本人の自白である場合には、有罪とされ、又は刑罰を科せられない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="39">
                <ArticleTitle>第三十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">何人も、実行の時に適法であつた行為又は既に無罪とされた行為については、刑事上の責任を問はれない。</Sentence>
                    <Sentence Num="2">又、同一の犯罪について、重ねて刑事上の責任を問はれない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="40">
                <ArticleTitle>第四十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、抑留又は拘禁された後、無罪の裁判を受けたときは、法律の定めるところにより、国にその補償を求めることができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="4">
              <ChapterTitle>第四章　国会</ChapterTitle>
              <Article Num="41">
                <ArticleTitle>第四十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国会は、国権の最高機関であつて、国の唯一の立法機関である。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="42">
                <ArticleTitle>第四十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国会は、衆議院及び参議院の両議院でこれを構成する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="43">
                <ArticleTitle>第四十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院は、全国民を代表する選挙された議員でこれを組織する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>両議院の議員の定数は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="44">
                <ArticleTitle>第四十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">両議院の議員及びその選挙人の資格は、法律でこれを定める。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、人種、信条、性別、社会的身分、門地、教育、財産又は収入によつて差別してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="45">
                <ArticleTitle>第四十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">衆議院議員の任期は、四年とする。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、衆議院解散の場合には、その期間満了前に終了する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="46">
                <ArticleTitle>第四十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>参議院議員の任期は、六年とし、三年ごとに議員の半数を改選する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="47">
                <ArticleTitle>第四十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>選挙区、投票の方法その他両議院の議員の選挙に関する事項は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="48">
                <ArticleTitle>第四十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>何人も、同時に両議院の議員たることはできない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="49">
                <ArticleTitle>第四十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院の議員は、法律の定めるところにより、国庫から相当額の歳費を受ける。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="50">
                <ArticleTitle>第五十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院の議員は、法律の定める場合を除いては、国会の会期中逮捕されず、会期前に逮捕された議員は、その議院の要求があれば、会期中これを釈放しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="51">
                <ArticleTitle>第五十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院の議員は、議院で行つた演説、討論又は表決について、院外で責任を問はれない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="52">
                <ArticleTitle>第五十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国会の常会は、毎年一回これを召集する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="53">
                <ArticleTitle>第五十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">内閣は、国会の臨時会の召集を決定することができる。</Sentence>
                    <Sentence Num="2">いづれかの議院の総議員の四分の一以上の要求があれば、内閣は、その召集を決定しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="54">
                <ArticleTitle>第五十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>衆議院が解散されたときは、解散の日から四十日以内に、衆議院議員の総選挙を行ひ、その選挙の日から三十日以内に、国会を召集しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">衆議院が解散されたときは、参議院は、同時に閉会となる。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、内閣は、国に緊急の必要があるときは、参議院の緊急集会を求めることができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>前項但書の緊急集会において採られた措置は、臨時のものであつて、次の国会開会の後十日以内に、衆議院の同意がない場合には、その効力を失ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="55">
                <ArticleTitle>第五十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">両議院は、各々その議員の資格に関する争訟を裁判する。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、議員の議席を失はせるには、出席議員の三分の二以上の多数による議決を必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="56">
                <ArticleTitle>第五十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院は、各々その総議員の三分の一以上の出席がなければ、議事を開き議決することができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>両議院の議事は、この憲法に特別の定のある場合を除いては、出席議員の過半数でこれを決し、可否同数のときは、議長の決するところによる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="57">
                <ArticleTitle>第五十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">両議院の会議は、公開とする。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、出席議員の三分の二以上の多数で議決したときは、秘密会を開くことができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>両議院は、各々その会議の記録を保存し、秘密会の記録の中で特に秘密を要すると認められるもの以外は、これを公表し、且つ一般に頒布しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>出席議員の五分の一以上の要求があれば、各議員の表決は、これを会議録に記載しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="58">
                <ArticleTitle>第五十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院は、各々その議長その他の役員を選任する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">両議院は、各々その会議その他の手続及び内部の規律に関する規則を定め、又、院内の秩序をみだした議員を懲罰することができる。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、議員を除名するには、出席議員の三分の二以上の多数による議決を必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="59">
                <ArticleTitle>第五十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>法律案は、この憲法に特別の定のある場合を除いては、両議院で可決したとき法律となる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>衆議院で可決し、参議院でこれと異なつた議決をした法律案は、衆議院で出席議員の三分の二以上の多数で再び可決したときは、法律となる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>前項の規定は、法律の定めるところにより、衆議院が、両議院の協議会を開くことを求めることを妨げない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="4">
                  <ParagraphNum>○４</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>参議院が、衆議院の可決した法律案を受け取つた後、国会休会中の期間を除いて六十日以内に、議決しないときは、衆議院は、参議院がその法律案を否決したものとみなすことができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="60">
                <ArticleTitle>第六十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>予算は、さきに衆議院に提出しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>予算について、参議院で衆議院と異なつた議決をした場合に、法律の定めるところにより、両議院の協議会を開いても意見が一致しないとき、又は参議院が、衆議院の可決した予算を受け取つた後、国会休会中の期間を除いて三十日以内に、議決しないときは、衆議院の議決を国会の議決とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="61">
                <ArticleTitle>第六十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>条約の締結に必要な国会の承認については、前条第二項の規定を準用する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="62">
                <ArticleTitle>第六十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>両議院は、各々国政に関する調査を行ひ、これに関して、証人の出頭及び証言並びに記録の提出を要求することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="63">
                <ArticleTitle>第六十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">内閣総理大臣その他の国務大臣は、両議院の一に議席を有すると有しないとにかかはらず、何時でも議案について発言するため議院に出席することができる。</Sentence>
                    <Sentence Num="2">又、答弁又は説明のため出席を求められたときは、出席しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="64">
                <ArticleTitle>第六十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国会は、罷免の訴追を受けた裁判官を裁判するため、両議院の議員で組織する弾劾裁判所を設ける。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>弾劾に関する事項は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="5">
              <ChapterTitle>第五章　内閣</ChapterTitle>
              <Article Num="65">
                <ArticleTitle>第六十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>行政権は、内閣に属する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="66">
                <ArticleTitle>第六十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣は、法律の定めるところにより、その首長たる内閣総理大臣及びその他の国務大臣でこれを組織する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>内閣総理大臣その他の国務大臣は、文民でなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>内閣は、行政権の行使について、国会に対し連帯して責任を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="67">
                <ArticleTitle>第六十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">内閣総理大臣は、国会議員の中から国会の議決で、これを指名する。</Sentence>
                    <Sentence Num="2">この指名は、他のすべての案件に先だつて、これを行ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>衆議院と参議院とが異なつた指名の議決をした場合に、法律の定めるところにより、両議院の協議会を開いても意見が一致しないとき、又は衆議院が指名の議決をした後、国会休会中の期間を除いて十日以内に、参議院が、指名の議決をしないときは、衆議院の議決を国会の議決とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="68">
                <ArticleTitle>第六十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">内閣総理大臣は、国務大臣を任命する。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、その過半数は、国会議員の中から選ばれなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>内閣総理大臣は、任意に国務大臣を罷免することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="69">
                <ArticleTitle>第六十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣は、衆議院で不信任の決議案を可決し、又は信任の決議案を否決したときは、十日以内に衆議院が解散されない限り、総辞職をしなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="70">
                <ArticleTitle>第七十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣総理大臣が欠けたとき、又は衆議院議員総選挙の後に初めて国会の召集があつたときは、内閣は、総辞職をしなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="71">
                <ArticleTitle>第七十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>前二条の場合には、内閣は、あらたに内閣総理大臣が任命されるまで引き続きその職務を行ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="72">
                <ArticleTitle>第七十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣総理大臣は、内閣を代表して議案を国会に提出し、一般国務及び外交関係について国会に報告し、並びに行政各部を指揮監督する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="73">
                <ArticleTitle>第七十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣は、他の一般行政事務の外、左の事務を行ふ。</Sentence>
                  </ParagraphSentence>
                  <Item Num="1">
                    <ItemTitle>一</ItemTitle>
                    <ItemSentence>
                      <Sentence>法律を誠実に執行し、国務を総理すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="2">
                    <ItemTitle>二</ItemTitle>
                    <ItemSentence>
                      <Sentence>外交関係を処理すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="3">
                    <ItemTitle>三</ItemTitle>
                    <ItemSentence>
                      <Sentence Num="1" Function="main">条約を締結すること。</Sentence>
                      <Sentence Num="2" Function="proviso">但し、事前に、時宜によつては事後に、国会の承認を経ることを必要とする。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="4">
                    <ItemTitle>四</ItemTitle>
                    <ItemSentence>
                      <Sentence>法律の定める基準に従ひ、官吏に関する事務を掌理すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="5">
                    <ItemTitle>五</ItemTitle>
                    <ItemSentence>
                      <Sentence>予算を作成して国会に提出すること。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="6">
                    <ItemTitle>六</ItemTitle>
                    <ItemSentence>
                      <Sentence Num="1" Function="main">この憲法及び法律の規定を実施するために、政令を制定すること。</Sentence>
                      <Sentence Num="2" Function="proviso">但し、政令には、特にその法律の委任がある場合を除いては、罰則を設けることができない。</Sentence>
                    </ItemSentence>
                  </Item>
                  <Item Num="7">
                    <ItemTitle>七</ItemTitle>
                    <ItemSentence>
                      <Sentence>大赦、特赦、減刑、刑の執行の免除及び復権を決定すること。</Sentence>
                    </ItemSentence>
                  </Item>
                </Paragraph>
              </Article>
              <Article Num="74">
                <ArticleTitle>第七十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>法律及び政令には、すべて主任の国務大臣が署名し、内閣総理大臣が連署することを必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="75">
                <ArticleTitle>第七十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">国務大臣は、その在任中、内閣総理大臣の同意がなければ、訴追されない。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、これがため、訴追の権利は、害されない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="6">
              <ChapterTitle>第六章　司法</ChapterTitle>
              <Article Num="76">
                <ArticleTitle>第七十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>すべて司法権は、最高裁判所及び法律の定めるところにより設置する下級裁判所に属する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">特別裁判所は、これを設置することができない。</Sentence>
                    <Sentence Num="2">行政機関は、終審として裁判を行ふことができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>すべて裁判官は、その良心に従ひ独立してその職権を行ひ、この憲法及び法律にのみ拘束される。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="77">
                <ArticleTitle>第七十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>最高裁判所は、訴訟に関する手続、弁護士、裁判所の内部規律及び司法事務処理に関する事項について、規則を定める権限を有する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>検察官は、最高裁判所の定める規則に従はなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>最高裁判所は、下級裁判所に関する規則を定める権限を、下級裁判所に委任することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="78">
                <ArticleTitle>第七十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">裁判官は、裁判により、心身の故障のために職務を執ることができないと決定された場合を除いては、公の弾劾によらなければ罷免されない。</Sentence>
                    <Sentence Num="2">裁判官の懲戒処分は、行政機関がこれを行ふことはできない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="79">
                <ArticleTitle>第七十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>最高裁判所は、その長たる裁判官及び法律の定める員数のその他の裁判官でこれを構成し、その長たる裁判官以外の裁判官は、内閣でこれを任命する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>最高裁判所の裁判官の任命は、その任命後初めて行はれる衆議院議員総選挙の際国民の審査に付し、その後十年を経過した後初めて行はれる衆議院議員総選挙の際更に審査に付し、その後も同様とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="3">
                  <ParagraphNum>○３</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>前項の場合において、投票者の多数が裁判官の罷免を可とするときは、その裁判官は、罷免される。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="4">
                  <ParagraphNum>○４</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>審査に関する事項は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="5">
                  <ParagraphNum>○５</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>最高裁判所の裁判官は、法律の定める年齢に達した時に退官する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="6">
                  <ParagraphNum>○６</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">最高裁判所の裁判官は、すべて定期に相当額の報酬を受ける。</Sentence>
                    <Sentence Num="2">この報酬は、在任中、これを減額することができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="80">
                <ArticleTitle>第八十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">下級裁判所の裁判官は、最高裁判所の指名した者の名簿によつて、内閣でこれを任命する。</Sentence>
                    <Sentence Num="2" Function="main">その裁判官は、任期を十年とし、再任されることができる。</Sentence>
                    <Sentence Num="3" Function="proviso">但し、法律の定める年齢に達した時には退官する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1">下級裁判所の裁判官は、すべて定期に相当額の報酬を受ける。</Sentence>
                    <Sentence Num="2">この報酬は、在任中、これを減額することができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="81">
                <ArticleTitle>第八十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>最高裁判所は、一切の法律、命令、規則又は処分が憲法に適合するかしないかを決定する権限を有する終審裁判所である。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="82">
                <ArticleTitle>第八十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>裁判の対審及び判決は、公開法廷でこれを行ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">裁判所が、裁判官の全員一致で、公の秩序又は善良の風俗を害する虞があると決した場合には、対審は、公開しないでこれを行ふことができる。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、政治犯罪、出版に関する犯罪又はこの憲法第三章で保障する国民の権利が問題となつてゐる事件の対審は、常にこれを公開しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="7">
              <ChapterTitle>第七章　財政</ChapterTitle>
              <Article Num="83">
                <ArticleTitle>第八十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国の財政を処理する権限は、国会の議決に基いて、これを行使しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="84">
                <ArticleTitle>第八十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>あらたに租税を課し、又は現行の租税を変更するには、法律又は法律の定める条件によることを必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="85">
                <ArticleTitle>第八十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国費を支出し、又は国が債務を負担するには、国会の議決に基くことを必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="86">
                <ArticleTitle>第八十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣は、毎会計年度の予算を作成し、国会に提出して、その審議を受け議決を経なければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="87">
                <ArticleTitle>第八十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>予見し難い予算の不足に充てるため、国会の議決に基いて予備費を設け、内閣の責任でこれを支出することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>すべて予備費の支出については、内閣は、事後に国会の承諾を得なければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="88">
                <ArticleTitle>第八十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">すべて皇室財産は、国に属する。</Sentence>
                    <Sentence Num="2">すべて皇室の費用は、予算に計上して国会の議決を経なければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="89">
                <ArticleTitle>第八十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>公金その他の公の財産は、宗教上の組織若しくは団体の使用、便益若しくは維持のため、又は公の支配に属しない慈善、教育若しくは博愛の事業に対し、これを支出し、又はその利用に供してはならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="90">
                <ArticleTitle>第九十条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>国の収入支出の決算は、すべて毎年会計検査院がこれを検査し、内閣は、次の年度に、その検査報告とともに、これを国会に提出しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>会計検査院の組織及び権限は、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="91">
                <ArticleTitle>第九十一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>内閣は、国会及び国民に対し、定期に、少くとも毎年一回、国の財政状況について報告しなければならない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="8">
              <ChapterTitle>第八章　地方自治</ChapterTitle>
              <Article Num="92">
                <ArticleTitle>第九十二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>地方公共団体の組織及び運営に関する事項は、地方自治の本旨に基いて、法律でこれを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="93">
                <ArticleTitle>第九十三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>地方公共団体には、法律の定めるところにより、その議事機関として議会を設置する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>地方公共団体の長、その議会の議員及び法律の定めるその他の吏員は、その地方公共団体の住民が、直接これを選挙する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="94">
                <ArticleTitle>第九十四条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>地方公共団体は、その財産を管理し、事務を処理し、及び行政を執行する権能を有し、法律の範囲内で条例を制定することができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="95">
                <ArticleTitle>第九十五条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>一の地方公共団体のみに適用される特別法は、法律の定めるところにより、その地方公共団体の住民の投票においてその過半数の同意を得なければ、国会は、これを制定することができない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="9">
              <ChapterTitle>第九章　改正</ChapterTitle>
              <Article Num="96">
                <ArticleTitle>第九十六条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">この憲法の改正は、各議院の総議員の三分の二以上の賛成で、国会が、これを発議し、国民に提案してその承認を経なければならない。</Sentence>
                    <Sentence Num="2">この承認には、特別の国民投票又は国会の定める選挙の際行はれる投票において、その過半数の賛成を必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>憲法改正について前項の承認を経たときは、天皇は、国民の名で、この憲法と一体を成すものとして、直ちにこれを公布する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="10">
              <ChapterTitle>第十章　最高法規</ChapterTitle>
              <Article Num="97">
                <ArticleTitle>第九十七条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>この憲法が日本国民に保障する基本的人権は、人類の多年にわたる自由獲得の努力の成果であつて、これらの権利は、過去幾多の試錬に堪へ、現在及び将来の国民に対し、侵すことのできない永久の権利として信託されたものである。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="98">
                <ArticleTitle>第九十八条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>この憲法は、国の最高法規であつて、その条規に反する法律、命令、詔勅及び国務に関するその他の行為の全部又は一部は、その効力を有しない。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>日本国が締結した条約及び確立された国際法規は、これを誠実に遵守することを必要とする。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="99">
                <ArticleTitle>第九十九条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>天皇又は摂政及び国務大臣、国会議員、裁判官その他の公務員は、この憲法を尊重し擁護する義務を負ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            <Chapter Num="11">
              <ChapterTitle>第十一章　補則</ChapterTitle>
              <Article Num="100">
                <ArticleTitle>第百条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>この憲法は、公布の日から起算して六箇月を経過した日から、これを施行する。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
                <Paragraph Num="2">
                  <ParagraphNum>○２</ParagraphNum>
                  <ParagraphSentence>
                    <Sentence>この憲法を施行するために必要な法律の制定、参議院議員の選挙及び国会召集の手続並びにこの憲法を施行するために必要な準備手続は、前項の期日よりも前に、これを行ふことができる。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="101">
                <ArticleTitle>第百一条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence>この憲法施行の際、参議院がまだ成立してゐないときは、その成立するまでの間、衆議院は、国会としての権限を行ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="102">
                <ArticleTitle>第百二条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1">この憲法による第一期の参議院議員のうち、その半数の者の任期は、これを三年とする。</Sentence>
                    <Sentence Num="2">その議員は、法律の定めるところにより、これを定める。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
              <Article Num="103">
                <ArticleTitle>第百三条</ArticleTitle>
                <Paragraph Num="1">
                  <ParagraphNum/>
                  <ParagraphSentence>
                    <Sentence Num="1" Function="main">この憲法施行の際現に在職する国務大臣、衆議院議員及び裁判官並びにその他の公務員で、その地位に相応する地位がこの憲法で認められてゐる者は、法律で特別の定をした場合を除いては、この憲法施行のため、当然にはその地位を失ふことはない。</Sentence>
                    <Sentence Num="2" Function="proviso">但し、この憲法によつて、後任者が選挙又は任命されたときは、当然その地位を失ふ。</Sentence>
                  </ParagraphSentence>
                </Paragraph>
              </Article>
            </Chapter>
            </MainProvision>
            </LawBody>
            </Law>
            </LawFullText>
            </ApplData>
            </DataRoot>

            """
    }
    
    

}

