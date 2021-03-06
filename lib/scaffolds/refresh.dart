import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../providers/settings.dart';
import '../widgets/loading.dart';
import '../widgets/error_reload.dart';

// This is a scaffold for pull to refresh
class RefreshScaffold<T> extends StatefulWidget {
  final Widget title;
  final Widget Function(T payload) bodyBuilder;
  final Future<T> Function() onRefresh;
  final Widget Function(T payload) trailingBuilder;
  // final List<Widget> Function(T payload) actionsBuilder;
  final PreferredSizeWidget bottom;

  RefreshScaffold({
    @required this.title,
    @required this.bodyBuilder,
    @required this.onRefresh,
    this.trailingBuilder,
    // this.actionsBuilder,
    this.bottom,
  });

  @override
  _RefreshScaffoldState createState() => _RefreshScaffoldState();
}

class _RefreshScaffoldState<T> extends State<RefreshScaffold<T>> {
  bool loading;
  T payload;
  String error = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Widget _buildBody() {
    if (error.isNotEmpty) {
      return ErrorReload(text: error, onTap: _refresh);
    } else if (payload == null) {
      return Loading(more: false);
    } else {
      return widget.bodyBuilder(payload);
    }
  }

  Future<void> _refresh() async {
    try {
      setState(() {
        error = '';
        loading = true;
      });
      payload = await widget.onRefresh();
    } catch (err) {
      error = err.toString();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget _buildTrailing() {
    if (payload == null || widget.trailingBuilder == null) return null;

    return widget.trailingBuilder(payload);
  }

  List<Widget> _buildActions() {
    if (payload == null || widget.trailingBuilder == null) return null;

    return [widget.trailingBuilder(payload)];
  }

  @override
  Widget build(BuildContext context) {
    switch (SettingsProvider.of(context).theme) {
      case ThemeMap.cupertino:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: widget.title,
            trailing: _buildTrailing(),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverRefreshControl(onRefresh: _refresh),
                SliverToBoxAdapter(child: _buildBody())
              ],
            ),
          ),
        );
      default:
        return Scaffold(
          appBar: AppBar(
            title: widget.title,
            actions: _buildActions(),
            bottom: widget.bottom,
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(child: _buildBody()),
          ),
        );
    }
  }
}
