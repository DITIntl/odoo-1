# -*- encoding: utf-8 -*-
#TODO: license from vauxoo
from openerp.osv import fields, osv
import os
import shutil
import logging
import glob
import time
from openerp.addons.runbot.runbot import RunbotController
import dateutil.parser
from openerp.addons.runbot.runbot import uniq_list
from openerp.addons.runbot.runbot import flatten
from openerp.http import request
from openerp import http
from openerp.addons.website.models.website import slug
from openerp.addons.website_sale.controllers.main import QueryURL
from openerp import SUPERUSER_ID

_logger = logging.getLogger(__name__)

def mkdirs(dirs):
    for d in dirs:
        if not os.path.exists(d):
            os.makedirs(d)

def decode_utf(field):
    try:
        return field.decode('utf-8')
    except UnicodeDecodeError:
        return ''


class runbot_prebuild_branch(osv.osv):
    _name = "runbot.prebuild.branch"
    _rec_name = 'branch_id'

    _columns = {
        'branch_id': fields.many2one('runbot.branch', 'Branch', required=True,
            ondelete='cascade', select=1),
        'check_pr': fields.boolean('Check PR',
            help='If is True, this will check Pull Request for this branch in this prebuild'),
        'sha': fields.char('SHA commit', size=40,
            help='Empty=Currently version\nSHA=Get this version in builds'),
        'prebuild_id': fields.many2one('runbot.prebuild', 'Pre-Build', required=True,
            ondelete='cascade', select=1),
        'repo_id': fields.related('branch_id', 'repo_id', type="many2one",
            relation="runbot.repo", string="Repository", readonly=True, store=True,
            ondelete='cascade', select=1),
    }


class runbot_team(osv.Model):
    '''
    Object used to create team to work in runbot
    '''

    _name = 'runbot.team'

    _columns = {
        'name': fields.char('Name', help='Name of the team'),
        'description': fields.text('Desciption', help='A little description of the team'),
    }

class runbot_prebuild(osv.osv):
    _name = "runbot.prebuild"

    _columns = {
        'name': fields.char("Name", size=128, required=True),
        'team_id': fields.many2one('runbot.team', 'Team', help='Team of work'),
        'module_branch_ids': fields.one2many('runbot.prebuild.branch', 'prebuild_id',
            string='Branches of modules', copy=True,
            help="Community addons branches which need to run tests."),
        'sticky': fields.boolean('Sticky', select=1,
            help="If True: Stay alive a instance ever. And check PR to main branch and"\
            " modules branches for make pre-builds\nIf False: Stay alive a instance only"\
            " moment and not check PR."),
        'modules': fields.char("Modules to Install", size=256,
            help="Empty is all modules availables"),
        'modules_to_exclude': fields.char("Modules to exclude", size=256,
            help="Empty is exclude none. Add modules is exclude this one. FEATURE TODO"),
        'language': fields.char("Language of instance", size=5,
            help="Language to change instance after of run test.\nFormat ll_CC<-language and country"),
        'script_prebuild': fields.text('Script Pre-Build',
            help="Script to execute before run build"),
        'script_posbuild': fields.text('Script Pos-Build',
            help="Script to execute after run build"),
        'prebuild_parent_id': fields.many2one('runbot.prebuild', 'Parent Prebuild', help="If this is a prebuild from PR this field is for set original prebuild"),
    }
    """
    def search_prebuild_pr(self, cr, uid, ids, context=None):
         #self.search(cr, uid, [('')])
        prebuild_branch_pool = self.poo.get('runbot.prebuild.branch')
        prebuild_branch_ids = prebuild_branch_pool.search(cr, uid, [('check_pr', '=', True), ('prebuild_id', '=', ids)], context=context )
        branch_id
    """
    #TODO: Add constraint that add prebuild_lines of least one main repo type
    
    def get_prebuilds_with_new_commit(self, cr, uid, ids, context=None):
        """
        Create build of sticky build with changes in your branches
        """
        build_pool = self.pool.get('runbot.build')
        build_line_pool = self.pool.get('runbot.build.line')
        repo_pool = self.pool.get('runbot.repo')
        branch_pool = self.pool.get('runbot.branch')
        for prebuild_sticky_id in ids:
            prebuild_child_ids = self.search(cr, uid, [('prebuild_parent_id', '=', prebuild_sticky_id)], context=context)
            build_ids = build_pool.search(cr, uid, [('prebuild_id', 'in', prebuild_child_ids + [prebuild_sticky_id])], context=context)
            build_line_ids = build_line_pool.search(cr, uid, [('build_id', 'in', build_ids)], context=context)
            if build_line_ids:
                query = "SELECT branch_id, repo_id FROM runbot_build_line WHERE id IN %s GROUP BY branch_id, repo_id"
                cr.execute( query, (tuple(build_line_ids),) )
                res = cr.fetchall()
                branch_ids = [ r[0] for r in res ]
                repo_ids = [ r[1] for r in res ]
                #build_line_branch_datas = build_line_pool.read(cr, uid, build_line_ids, ['branch_id'], context=context)
                #branch_ids = list( set([build_line_branch_data['branch_id'] for build_line_branch_data in build_line_branch_datas]) )
                #for r in res:
                    #repo_pool.get_ref_data(cr, uid, [r[0]], r[1], context=None):
                #TODO: update repo_ids
                for branch in branch_pool.browse(cr, uid, branch_ids, context=context):
                    refs = repo_pool.get_ref_data(cr, uid, [branch.repo_id.id], branch.name, context=context)
                    if refs and refs[branch.repo_id.id]:
                        ref_data = refs[branch.repo_id.id][0]
                        sha = ref_data['sha']
                        build_line_with_sha_ids = build_line_pool.search(cr, uid, [('build_id', 'in', build_ids), ('sha', '=', sha)], context=context, limit=1)
                        if not build_line_with_sha_ids:
                            pass#TODO: Make it
                            #But in this point checkout should be functionallity with sha previous.
            else:
                pass#TODO: Create build if not exists 
        return {}

    def create_prebuild_pr(self, cr, uid, ids, context=None):
        """
        Create prebuild from pull request with branches pr_check=True and prebuild sticky=True
        """
        new_prebuild_ids = [ ]
        branch_pool = self.pool.get('runbot.branch')
        prebuild_line_pool = self.pool.get('runbot.prebuild.branch')
        for prebuild in self.browse(cr, uid, ids, context=context):
            for prebuild_line in prebuild.module_branch_ids:
                if prebuild_line.check_pr:
                    branch_pr_ids = branch_pool.search(cr, uid, [('branch_base_id', '=', prebuild_line.branch_id.id)], context=context)
                    #Get prebuild childs
                    prebuild_child_ids = self.search(cr, uid, [('prebuild_parent_id', '=', prebuild.id)], context=context )
                    for branch_pr in branch_pool.browse(cr, uid, branch_pr_ids, context=context):
                        prebuild_pr_ids = prebuild_line_pool.search(cr, uid, [('branch_id', '=', branch_pr.id), ('prebuild_id', 'in', prebuild_child_ids)], limit=1)
                        if prebuild_pr_ids:
                            #if exist prebuild of pr no create new one
                            continue
                        #If not exist prebuild of this pr then create one
                        new_prebuild_pr_id = self.copy(cr, uid, prebuild.id, {
                            'name': prebuild.name + ' - ' + branch_pr.complete_name,
                            'prebuild_parent_id': prebuild.id,
                            'sticky': False,
                        }, context=context)
                        
                        #Search prebuild lines for set check_pr = False. For not check pr of childs.
                        new_prebuild_line_ids = prebuild_line_pool.search(cr, uid, [
                            ('prebuild_id', '=', new_prebuild_pr_id),
                        ], context=context)
                        for new_prebuild_line in prebuild_line_pool.browse(cr, uid, new_prebuild_line_ids, context):
                            new_data = { 'check_pr': False}
                            if new_prebuild_line.branch_id.id == prebuild_line.branch_id.id:
                                #Replace branch base by branch pr in new pre-build
                                new_data.update({'branch_id': branch_pr.id})
                            prebuild_line_pool.write(cr, uid, [new_prebuild_line.id], new_data, context=context)
                        new_prebuild_ids.append( new_prebuild_pr_id )
        return new_prebuild_ids

    def create_build(self, cr, uid, ids, context=None):
        if context is None:
            context = {}
        repo_obj = self.pool.get('runbot.repo')
        build_obj = self.pool.get('runbot.build')
        build_ids = []
        for prebuild in self.browse(cr, uid, ids, context=context):
            #Update repository but no create default build
            context.update({'create_builds': False})
            
            #Get build_line current info
            build_line_datas = []
            for prebuild_line in prebuild.module_branch_ids:
                refs = repo_obj.get_ref_data(cr, uid, [prebuild_line.branch_id.repo_id.id], prebuild_line.branch_id.name, context=context)
                if refs and refs[prebuild_line.repo_id.id]:
                    ref_data = refs[prebuild_line.repo_id.id][0]
                    ref_data.update({'branch_id': prebuild_line.branch_id.id})
                    build_line_datas.append( (0, 0, ref_data) )

            build_info = {
                'branch_id': prebuild_line.branch_id.id,#Any branch. Not use it. Last of for.
                'name': prebuild.name,#TODO: Get this value
                'author': prebuild.name,#TODO: Get this value
                'subject': prebuild.name,#TODO: Get this value
                'date': time.strftime("%Y-%m-%d %H:%M:%S"),#TODO: Get this value
                'modules': prebuild.modules,
                'prebuild_id': prebuild.id,#Important field for custom build and custom checkout
                'team_id': prebuild and prebuild.team_id and prebuild.team_id.id or False,
                'line_ids': build_line_datas,
            }
            build_id = build_obj.create(cr, uid, build_info)
            build_ids.append( build_id )
        return build_ids

class runbot_branch(osv.osv):
    _inherit = "runbot.branch"

    def name_get(self, cr, uid, ids, context=None):
        if isinstance(ids, (list, tuple)) and not len(ids):
            return []
        if isinstance(ids, (long, int)):
            ids = [ids]
        res_name = super(runbot_branch, self).name_get(cr, uid, ids, context=context)
        res = []
        for record in res_name:
            branch = self.browse(cr, uid, [record[0]], context=context)[0]
            name = '[' + record[1] + '] ' + branch.repo_id.name
            res.append((record[0], name))
        return res

class runbot_build(osv.osv):
    _inherit = "runbot.build"

    _columns = {
        'prebuild_id': fields.many2one('runbot.prebuild', string='Runbot Pre-Build',
            required=False, help="This is the origin of instance data."),
        'line_ids': fields.one2many('runbot.build.line', 'build_id',
            string='Build branches lines', readonly=True),
        'team_id': fields.many2one('runbot.team', 'Team', help='Team of work'),
    }

    def force_schedule(self, cr, uid, ids, context=None):
        if context is None:
            context = {}
        context.update({'build_ids': ids})
        build_obj = self.pool.get('runbot.repo')
        return build_obj.scheduler(cr, uid, ids=None, context=context)

    def checkout_prebuild(self, cr, uid, ids, context=None):
        branch_obj = self.pool.get('runbot.branch')
        build_line_obj = self.pool.get('runbot.build.line')
        #main_branch = branch_obj.browse(cr, uid, [main_branch_id], context=context)[0]
        for build in self.browse(cr, uid, ids, context=context):
            if build.prebuild_id:
                # starts from scratch
                if os.path.isdir(build.path()):
                    shutil.rmtree(build.path())
                _logger.debug('Creating build in path "%s"'%( build.path() ))

                # runbot log path
                mkdirs([build.path("logs"), build.server('addons')])

                # v6 rename bin -> openerp
                if os.path.isdir(build.path('bin/addons')):
                    shutil.move(build.path('bin'), build.server())
                
                for build_line in build.line_ids:
                    if build_line.repo_id.type == 'main':
                        path = build.path()
                    elif build_line.repo_id.type == 'module':
                        path = build.server("addons")
                    else:
                        pass #TODO: raise error
                    build_line.repo_id.git_export( build_line.sha or build_line.branch_id.name, path )
                # move all addons to server addons path
                for module in glob.glob( build.path('addons/*') ):
                    shutil.move(module, build.server('addons'))

    def checkout(self, cr, uid, ids, context=None):
        for build in self.browse(cr, uid, ids, context=context):
            if not build.prebuild_id:
                #TODO: Split branches for use same function "checkout_params"
                return super(runbot_build, self).checkout(cr, uid, ids, context=context)
            else:
                #module_branch_ids = [module_branch_id.branch_id.id for module_branch_id in build.prebuild_id.module_branch_ids]
                #self.checkout_params(cr, uid, [build.id], module_branch_ids=module_branch_ids, modules_to_test=build.prebuild_id.modules, context=context)
                self.checkout_prebuild(cr, uid, [build.id], context=context)

class runbot_build_line(osv.osv):
    _name = 'runbot.build.line'
    _rec_name = 'sha'

    _columns = {
        'build_id': fields.many2one('runbot.build', 'Build', required=True,
            ondelete='cascade', select=1),
        'branch_id': fields.many2one('runbot.branch', 'Branch', required=True,
            ondelete='cascade', select=1),
        'refname': fields.char('Ref Name'),
        'sha': fields.char('SHA commit', size=40,
            help='Version of commit or sha', required=True),
        'date': fields.datetime('Commit date'),
        'author': fields.char('Author'),
        'subject': fields.text('Subject'),
        'committername': fields.char('Committer'),
        'repo_id': fields.related('branch_id', 'repo_id', type="many2one", \
            relation="runbot.repo", string="Repository", readonly=True, store=True, \
            ondelete='cascade', select=1),
    }

class runbot_repo(osv.osv):
    _inherit = "runbot.repo"

    def get_ref_data(self, cr, uid, ids, ref, context=None):
        res = {}
        for repo in self.browse(cr, uid, ids, context=context):
            res[repo.id] = []
            fields = ['refname','objectname','committerdate:iso8601','authorname','subject','committername']
            fmt = "%00".join(["%("+field+")" for field in fields])
            git_refs = repo.git(['for-each-ref', '--format', fmt, '--sort=-committerdate', ref])
            if git_refs:
                git_refs = git_refs.strip()
                refs = [[decode_utf(field) for field in line.split('\x00')] for line in git_refs.split('\n')]
                for refname, objectname, committerdate, author, subject, committername in refs:
                    res[repo.id].append({
                        'refname': refname,
                        'sha': objectname,
                        'date': dateutil.parser.parse(committerdate[:19]),
                        'author': author,
                        'subject': subject,
                        'committername': committername,
                    })
        return res

    def cron(self, cr, uid, ids=None, context=None):
        prebuild_pool = self.pool.get('runbot.prebuild')
        prebuild_sticky_ids = prebuild_pool.search(cr, uid, [('sticky', '=', True)], context=context)
        prebuild_pr_ids = prebuild_pool.create_prebuild_pr(cr, uid, prebuild_sticky_ids, context=context)
        #build_ids = prebuild_pool.create_build(cr, uid, prebuild_pr_ids, context=context)
        prebuild_pool.get_prebuilds_with_new_commit(cr, uid, prebuild_sticky_ids, context=context)
        return super(runbot_repo, self).cron(cr, uid, ids, context=context)

class RunbotController(RunbotController):

    @http.route(['/runbot',
                 '/runbot/repo/<model("runbot.repo"):repo>',
                 '/runbot/team/<model("runbot.team"):team>'],
                 type='http', auth="public", website=True)
    def repo(self, repo=None, team=None, search='', limit='100', refresh='', **post):
        registry, cr, uid = request.registry, request.cr, SUPERUSER_ID
        res = super(RunbotController, self).repo(repo=repo, search=search, limit=limit, refresh=refresh, **post)

        branch_obj = registry['runbot.branch']
        build_obj = registry['runbot.build']
        team_obj = registry['runbot.team']
        repo_obj = registry['runbot.repo']
        team_ids = team_obj.search(cr, uid, [], order='id')
        teams = team_obj.browse(cr, uid, team_ids)
        res.qcontext.update({'teams':teams})
        if team:
            filters = {key: post.get(key, '1') for key in ['pending', 'testing', 'running', 'done']}
            build_ids = build_obj.search(cr, uid, [('team_id', '=', team.id)], limit=int(limit))
            branch_ids, build_by_branch_ids = [], {}

            if build_ids:
                branch_query = """
                    SELECT br.id AS branch_id,
                        bu.branch_dependency_id,
                        CASE WHEN br.sticky AND bu.branch_dependency_id IS NULL THEN True
                             ELSE False
                        END AS real_sticky
                    FROM runbot_branch br
                    INNER JOIN runbot_build bu
                       ON br.id=bu.branch_id
                    WHERE bu.id in %s
                    ORDER BY real_sticky DESC, bu.sequence DESC--, br.id DESC, bu.branch_dependency_id DESC
                """
                #sticky_dom = [('repo_id','=',repo.id), ('sticky', '=', True)]
                #sticky_branch_ids = [] if search else branch_obj.search(cr, uid, sticky_dom)
                cr.execute(branch_query, (tuple(build_ids),))
                branch_ids = uniq_list( [(br[0], br[1] or None) for br in cr.fetchall()] )

                build_query = """
                    SELECT
                        branch_id,
                        branch_dependency_id,
                        max(case when br_bu.row = 1 then br_bu.build_id end),
                        max(case when br_bu.row = 2 then br_bu.build_id end),
                        max(case when br_bu.row = 3 then br_bu.build_id end),
                        max(case when br_bu.row = 4 then br_bu.build_id end)
                    FROM (
                        SELECT
                            br.id AS branch_id,
                            bu.id AS build_id,
                            bu.branch_dependency_id AS branch_dependency_id,
                            row_number() OVER (PARTITION BY branch_id, bu.branch_dependency_id ORDER BY bu.id DESC) AS row
                        FROM
                            runbot_branch br INNER JOIN runbot_build bu ON br.id=bu.branch_id
                        WHERE bu.id in %s
                        GROUP BY br.id, branch_dependency_id, bu.id
                    ) AS br_bu
                    WHERE
                        row <= 4
                    GROUP BY br_bu.branch_id, br_bu.branch_dependency_id
                """
                cr.execute(build_query, (tuple(build_ids),))
                build_by_branch_ids = {
                    (rec[0], rec[1]): [r for r in rec[2:] if r is not None] for rec in cr.fetchall()
                }

            #branches = branch_obj.browse(cr, uid, branch_ids, context=request.context)
            build_ids = flatten(build_by_branch_ids.values())
            build_dict = {build.id: build for build in build_obj.browse(cr, uid, build_ids, context=request.context) }

            def branch_info(branch, branch_dependency):
                return {
                    'branch': branch,
                    'branch_dependency': branch_dependency,
                    'builds': [self.build_info(build_dict[build_id]) for build_id in build_by_branch_ids[branch.id, branch_dependency and branch_dependency.id or None]]
                }

            res.qcontext.update({
                'branches': [ branch_info(
                                branch_obj.browse(cr, uid, [branch_id], context=request.context)[0],\
                                branch_obj.browse(cr, uid, [branch_dependency_id], context=request.context)[0]\
                         ) \
                         for branch_id, branch_dependency_id in branch_ids ],
                'testing': build_obj.search_count(cr, uid, [('team_id','=',team.id), ('state','=','testing')]),
                'team': team,
                'running': build_obj.search_count(cr, uid, [('team_id','=',team.id), ('state','=','running')]),
                'pending': build_obj.search_count(cr, uid, [('team_id','=',team.id), ('state','=','pending')]),
                'qu': QueryURL('/runbot/team/'+slug(team), search=search, limit=limit, refresh=refresh, **filters),
                'filters': filters,
            })

        return res


    def build_info(self, build):
        res = super(RunbotController, self).build_info(build)
        res.update({'prebuild_id':build.prebuild_id,
                    'build':build})
        return res
