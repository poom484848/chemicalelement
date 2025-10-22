import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../element/data/element_provider.dart';
import 'element_form_page.dart';

class ElementListPage extends StatefulWidget {
  const ElementListPage({super.key});

  @override
  State<ElementListPage> createState() => _ElementListPageState();
}

class _ElementListPageState extends State<ElementListPage> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
      context.read<ElementProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ElementProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Periodic Table (SQLite)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'ค้นหา: H / Hydrogen / ไฮโดรเจน',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: prov.setQuery,
            ),
          ),
          Expanded(
            child: prov.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemCount: prov.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (_, i) {
                    final e = prov.items[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text(e.symbol)),
                      title: Text('${e.atomicNumber}. ${e.nameTh} (${e.nameEn})'),
                      subtitle: Text('หมู่: ${e.group ?? "-"}  •  คาบ: ${e.period}  •  ประเภท: ${e.category.name}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('ลบธาตุ?'),
                              content: Text('ลบ ${e.symbol} - ${e.nameTh}?'),
                              actions: [
                                TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('ยกเลิก')),
                                FilledButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('ลบ')),
                              ],
                            ),
                          );
                          if (ok == true) { await prov.remove(e.id!); }
                        },
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ElementFormPage(editing: e)),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ElementFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มธาตุ'),
      ),
    );
  }
}
