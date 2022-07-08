"""${message}

Revision ID: ${up_revision}
Revises: ${down_revision | comma,n}
Create Date: ${create_date}

"""
from alembic import op
import sqlalchemy as sa
${imports if imports else ""}

# revision identifiers, used by Alembic.
revision = ${repr(up_revision)}
down_revision = ${repr(down_revision)}
branch_labels = ${repr(branch_labels)}
depends_on = ${repr(depends_on)}


def upgrade():
    ${upgrades if upgrades else "pass"}

     # ! DO NOT REMOVE THIS QUERY FROM MIGRATION - updates the db_change_log
    op.execute("""
        INSERT INTO db_change_log (revision_id, migration_description, migration_type)
        VALUES (${repr(up_revision)}, ${repr(message)}, 'upgrade')
    """)

def downgrade():
    ${downgrades if downgrades else "pass"}
    # ! DO NOT REMOVE THIS QUERY FROM MIGRATION - updates the db_change_log
    op.execute("""
        INSERT INTO db_change_log (revision_id, migration_description, migration_type)
        VALUES (${repr(up_revision)}, ${repr(message)}, 'downgrade')
    """)