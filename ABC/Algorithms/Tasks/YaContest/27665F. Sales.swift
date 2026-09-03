/*
https://contest.yandex.ru/contest/27665/problems/F
*/

func sales() {
    var dict: [String: [String: Int]] = [:]

    while let text = readLine() {
        let comps = text.split(separator: " ").map { String($0) }
        let buyer = comps[0]
        let product = comps[1]
        let qty = Int(comps[2]) ?? 0

        if dict[buyer] != nil {
            if let n = dict[buyer]?[product] {
                dict[buyer]?[product] = n + qty
            } else {
                dict[buyer]?[product] = qty
            }
        } else {
            dict[buyer] = [product: qty]
        }
    }

    var names: [String] = Array(dict.keys)

    names.sort()

    for name in names {
        print("\(name):")

        dict[name]?.map { ($0.key, $0.value) }
            .sorted(by: { $0.0 <= $1.0 })
            .forEach { print("\($0.0) \($0.1)") } 
    }
}
