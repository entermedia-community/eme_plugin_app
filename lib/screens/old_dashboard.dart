import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import '../widgets/tutorial_card.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final VoidCallback? onLogout;

  const DashboardScreen({super.key, required this.username, this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeEnvironment = 'DEMO 1';
  bool isGridView = true;
  String selectedTab = 'Catalog';
  String selectedFilter1 = 'All Subjects';
  String selectedFilter2 = 'All States';
  String searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) selectedTab = 'Wall';
        if (_tabController.index == 1) selectedTab = 'Catalog';
        if (_tabController.index == 2) selectedTab = 'Achievements';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tutorial> get filteredTutorials {
    return mockTutorials.where((tutorial) {
      final matchesSearch =
          tutorial.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          tutorial.category.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedFilter1 == 'All Subjects' ||
          (selectedFilter1 == 'Math' &&
              tutorial.category.contains('MATEMÁTICA')) ||
          (selectedFilter1 == 'Science' &&
              tutorial.category.contains('CIENCIAS')) ||
          (selectedFilter1 == 'Language' &&
              tutorial.category.contains('LENGUAJE')) ||
          (selectedFilter1 == 'History' &&
              tutorial.category.contains('HISTORIA'));

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F13), Color(0xFF141923), Color(0xFF0F1319)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Sleek Modern Header
              _buildHeader(context, isDesktop),

              // 2. Navigation Tabs
              _buildTabBar(theme),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page title & controls row
                      _buildTitleAndControls(isDesktop),
                      const SizedBox(height: 20),

                      // Filters section
                      _buildFiltersRow(isDesktop),
                      const SizedBox(height: 24),

                      // Competency Level Indicator header
                      _buildCompetencyOverviewHeader(),
                      const SizedBox(height: 20),

                      // Tutorial Grid/List dynamic content
                      filteredTutorials.isEmpty
                          ? _buildEmptyState()
                          : isGridView
                          ? _buildTutorialGrid(isDesktop)
                          : _buildTutorialList(isDesktop),

                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          'Powered by eMe.world',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white30,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.4),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF263238), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Menu + Logo/Avatar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white70),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              const SizedBox(width: 8),
              // Profile Thumbnail Only
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38B6FF).withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: const Image(image: AssetImage('assets/logo.png')),
                ),
              ),
            ],
          ),

          // Right side: Interactive Notifications + Analytics Status
          Row(
            children: [
              // Notifications Dropdown
              PopupMenuButton<int>(
                offset: const Offset(0, 48),
                color: const Color(0xFF161C24),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: Color(0xFF38B6FF),
                        ),
                      ),
                    ),
                    // Live red dot badge indicating new notifications
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF50057),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onSelected: (int val) {
                  // Interactive notification action (e.g. click item)
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: -1,
                    enabled: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF50057,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '3 New',
                            style: TextStyle(
                              color: Color(0xFFF50057),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  PopupMenuItem<int>(
                    value: 0,
                    child: _buildNotificationItem(
                      title: 'New Tutorial Available',
                      body: 'Mathematical Competence 2 has been unlocked.',
                      time: '5m ago',
                      isNew: true,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: _buildNotificationItem(
                      title: 'Achievement Unlocked',
                      body: 'You completed 3 subject diagnostic tests.',
                      time: '2h ago',
                      isNew: true,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: _buildNotificationItem(
                      title: 'Forgetting Threshold',
                      body: 'Physics effectiveness has dropped to Moderate.',
                      time: '1d ago',
                      isNew: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String time,
    required bool isNew,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isNew)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF38B6FF),
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isNew ? Colors.white : Colors.white70,
                    fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0F1319),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0F13), Color(0xFF141923)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Drawer Header (Profile Info relocated here)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF50057), Color(0xFF2196F3)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFF50057,
                                ).withValues(alpha: 0.2),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.username.isNotEmpty
                                  ? widget.username[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username.isNotEmpty
                                  ? widget.username.split('@')[0]
                                  : 'User',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.username.isNotEmpty
                                  ? widget.username
                                  : 'user@emeworld.com',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF90A4AE),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Navigation Items (Middle)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.dashboard_rounded,
                      title: 'Catalog / Dashboard',
                      selected: selectedTab == 'Catalog',
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTab = 'Catalog';
                          _tabController.index = 1;
                        });
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.bubble_chart_rounded,
                      title: 'Wall',
                      selected: selectedTab == 'Wall',
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTab = 'Wall';
                          _tabController.index = 0;
                        });
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.emoji_events_rounded,
                      title: 'Achievements',
                      selected: selectedTab == 'Achievements',
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTab = 'Achievements';
                          _tabController.index = 2;
                        });
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.analytics_outlined,
                      title: 'Performance Analytics',
                      selected: false,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              // 3. Bottom: Environment dropdown + Red Logout option
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'ENVIRONMENT',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2631),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _activeEnvironment,
                          dropdownColor: const Color(0xFF1E2631),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white70,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _activeEnvironment = newValue;
                              });
                            }
                          },
                          items: <String>['DEMO 1', 'DEMO 2']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: value == 'DEMO 1'
                                              ? const Color(0xFF0072FF)
                                              : const Color(0xFF8A2387),
                                        ),
                                        child: const Icon(
                                          Icons.school,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Logout Option
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (widget.onLogout != null) widget.onLogout!();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF50057,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFF50057,
                            ).withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 16,
                              color: Color(0xFFF50057),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Log Out',
                              style: TextStyle(
                                color: Color(0xFFF50057),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Powered by eMe.world',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white30,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF38B6FF).withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? const Color(0xFF38B6FF).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? const Color(0xFF38B6FF) : Colors.white54,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.2),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF263238), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorColor: const Color(0xFF38B6FF),
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 0.8,
        ),
        tabs: const [
          Tab(text: 'WALL'),
          Tab(text: 'CATALOG'),
          Tab(text: 'ACHIEVEMENTS'),
        ],
      ),
    );
  }

  Widget _buildTitleAndControls(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildTitile(isDesktop), _buildViewSwitcher(isDesktop)],
    );
  }

  Widget _buildTitile(bool isDesktop) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //align left
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Academic Catalog',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSwitcher(bool isDesktop) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2631),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => isGridView = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isGridView
                      ? const Color(0xFF2C394B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isGridView
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      size: 16,
                      color: isGridView ? Colors.white : Colors.white38,
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 6),
                      Text(
                        'Cards',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isGridView ? Colors.white : Colors.white38,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => isGridView = false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: !isGridView
                      ? const Color(0xFF2C394B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !isGridView
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.view_list_rounded,
                      size: 16,
                      color: !isGridView ? Colors.white : Colors.white38,
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 6),
                      Text(
                        'List',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !isGridView ? Colors.white : Colors.white38,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(flex: 2, child: _buildSearchBar()),
          const SizedBox(width: 16),
          Expanded(child: _buildDropdownFilter1()),
          const SizedBox(width: 16),
          Expanded(child: _buildDropdownFilter2()),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDropdownFilter1()),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdownFilter2()),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search topics, tutorials...',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter1() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter1,
          dropdownColor: const Color(0xFF161C24),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedFilter1 = newValue;
              });
            }
          },
          items:
              <String>[
                'All Subjects',
                'Math',
                'Science',
                'Language',
                'History',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter2() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter2,
          dropdownColor: const Color(0xFF161C24),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedFilter2 = newValue;
              });
            }
          },
          items: <String>['All States', 'Critical', 'Warning', 'On Track']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCompetencyOverviewHeader() {
    final criticalCount = mockTutorials
        .where((c) => c.progress.getAverageProgress() <= 0.3)
        .length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF50057).withValues(alpha: 0.08),
            const Color(0xFF0F1319).withValues(alpha: 0.0),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF50057).withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF50057).withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF50057),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Competency Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You have $criticalCount priority areas that need attention',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.white24),
          SizedBox(height: 12),
          Text(
            'No matching tutorials found',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialGrid(bool isDesktop) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 2 : 1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 475,
      ),
      itemCount: filteredTutorials.length,
      itemBuilder: (context, index) {
        return TutorialCard(
          tutorial: filteredTutorials[index],
          isListMode: false,
        );
      },
    );
  }

  Widget _buildTutorialList(bool isDesktop) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTutorials.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TutorialCard(
          tutorial: filteredTutorials[index],
          isListMode: true,
        );
      },
    );
  }
}
